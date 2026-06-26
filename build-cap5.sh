#!/usr/bin/env bash
set -euo pipefail
################################################################################
# Name:         build-cap5
# File:         build-cap5.sh
# Purpose:      Build the cap5 distribution (rpm|deb|tgz)
# Bug Reports:  cap5-devel_AT_lists_DOT_sf_DOT_net
#
# Copyright:
# © Copyright 2012 Hewlett-Packard Development Company, L.P
#
# License: GPL v2
################################################################################

if [[ -z "${CAP5DEVHOME:-}" ]]; then
    echo "Define CAP5DEVHOME!" >&2
    exit 1
fi
if [[ $# -ne 2 ]]; then
    echo "$0 official|snapshot rpm|srpm|deb|tgz" >&2
    exit 1
fi
PKGTYPE="$1"
PKG="$2"

VERSION=$(grep "^Version:" "${CAP5DEVHOME}/cap.spec" | awk '{print $2}')

#
# BEGIN: get source versions from repo
#
git_version() {
    GITVERSION=$(git describe --always)
    GITMODIFIED=$(git status | grep -qE 'modified:|added:|deleted:' && echo "_M" || true)
    RELEASE="${GITVERSION}${GITMODIFIED}"
}

svn_version() {
    RELEASE=$(svnversion "${CAP5DEVHOME}" | cut -f2 -d ":")
}
#
# END: get source versions from repo
#

RELEASE=''

# determine the package type
if [[ "${PKGTYPE}" == "snapshot" ]]; then
    [[ -d .svn ]] && [[ -z "${RELEASE}" ]] && svn_version
    [[ -d .git ]] && [[ -z "${RELEASE}" ]] && git_version
    REL_SEDCMD="s/RELEASE/1_${RELEASE}/g"
elif [[ "${PKGTYPE}" == "official" ]]; then
    REL_SEDCMD="s/RELEASE/1/g"
else
    echo "$0: ${PKGTYPE} is not supported at this time" >&2
    exit 1
fi


#
# helper maketgz function
#
maketgz() {
    local distro="${1:-}"
    local sedcmd
    sedcmd="s/$(echo "${CAP5DEVHOME}" | sed 's/\//\\\//g')//g"
    local exclude=''
    if [[ -d .svn ]]; then
        exclude=$(for file in $(svn stat "${CAP5DEVHOME}" | sed "${sedcmd}" | grep "?" | awk '{print $2}'); do
            echo -n " --exclude ${file}"
        done)
    fi
    local base_dir="cap-${VERSION}"
    local source_base_dir="${TMPDIR:-/tmp}/cap5_src_work"
    if [[ -d "${source_base_dir}" ]]; then
        rm -fr "${source_base_dir}"
    fi
    mkdir -p "${source_base_dir}"
    local source_build_root="${source_base_dir}/${base_dir}"
    # shellcheck disable=SC2086
    rsync -a --exclude '*.svn' --exclude '*.git' ${exclude} --delete \
        "${CAP5DEVHOME}/" "${source_build_root}"

    sed "${REL_SEDCMD}" "${CAP5DEVHOME}/cap.spec" > "${source_build_root}/.spec"

    cd "${source_build_root}" && rm -f build-cap5.sh cap.spec Makefile GNUmakefile git.setup
    if [[ "${distro}" != "debian" ]]; then
        rm -rvf "${source_build_root}/debian"
    fi
    cd "${source_base_dir}"
    local dist_tgz
    if [[ "${PKGTYPE}" != "official" && "${PKG}" == "tgz" ]]; then
        dist_tgz="${base_dir}-${RELEASE}.tar.gz"
    else
        dist_tgz="${base_dir}.tar.gz"
    fi
    tar -zcf "${dist_tgz}" "${base_dir}"
    # export for use by callers
    SOURCE_BASE_DIR="${source_base_dir}"
    DIST_TGZ="${dist_tgz}"
}


if [[ "${PKG}" == "rpm" || "${PKG}" == "srpm" ]]; then
    maketgz
    uid=$(id -u)
    if [[ "${uid}" -ne 0 ]]; then
        if [[ ! -f "${HOME}/.rpmmacros" ]]; then
            cat << EOF > "${HOME}/.rpmmacros"
%_topdir /home/${USER}/redhat
EOF
            mkdir -p "${HOME}/redhat"
            mkdir -p "${HOME}/redhat/"{BUILD,RPMS,SOURCES,SPECS,SRPMS,tmp}
        fi
    fi
    if [[ "${PKG}" == "srpm" ]]; then
        rpmbuild -ts "${SOURCE_BASE_DIR}/${DIST_TGZ}"
    else
        rpmbuild -tb "${SOURCE_BASE_DIR}/${DIST_TGZ}"
    fi
elif [[ "${PKG}" == "deb" ]]; then
    maketgz debian
    DEB_STAGING=$(mktemp -d)
    trap 'rm -rf "${DEB_STAGING}"' EXIT
    cd "${CAP5DEVHOME}"
    "${CAP5DEVHOME}/install.sh" "${DEB_STAGING}"
    cd "${SOURCE_BASE_DIR}/cap-${VERSION}"
    cp -r debian/DEBIAN "${DEB_STAGING}"
    sed "${REL_SEDCMD}" "${CAP5DEVHOME}/debian/DEBIAN/control" > "${DEB_STAGING}/DEBIAN/control"
    if [[ -z "${RELEASE:-}" ]]; then
        DIST_DEB="cap-${VERSION}-1.deb"
    else
        DIST_DEB="cap-${VERSION}-1_${RELEASE}.deb"
    fi
    dpkg -b "${DEB_STAGING}" "${CAP5DEVHOME}/${DIST_DEB}"
    echo "${PKGTYPE} cap5 ${PKG} located in ${CAP5DEVHOME}/${DIST_DEB}"
elif [[ "${PKG}" == "tgz" ]]; then
    maketgz
    cp -f "${SOURCE_BASE_DIR}/${DIST_TGZ}" "${CAP5DEVHOME}"
    echo "${PKGTYPE} cap5 ${PKG} located in ${CAP5DEVHOME}/${DIST_TGZ}"
else
    echo "$0: ${PKG} is not supported at this time" >&2
    exit 1
fi

# cleanup any leftovers
rm -rf "${SOURCE_BASE_DIR}"
