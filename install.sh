#!/usr/bin/env bash
set -euo pipefail
############################################################################
# Name:       install
# File:       install.sh
# Purpose:    install cap to build root directory
# Bug Reports: cap5-devel_AT_lists_DOT_sf_DOT_net
#
# Copyright:
# © Copyright 2006, 2007, 2012 Hewlett-Packard Development Company, L.P
#
# License: GPL v2
############################################################################

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 BUILD_ROOT [_cap_home]" >&2
    exit 1
fi

BUILD_ROOT="${1}"
_cap_home="${2:-/opt/cap5}"

# bins
mkdir -p "${BUILD_ROOT}/${_cap_home}/bin"
cp -a deploy "${BUILD_ROOT}/${_cap_home}/bin/"

# src
mkdir -p "${BUILD_ROOT}/${_cap_home}/src"
cp -a src/. "${BUILD_ROOT}/${_cap_home}/src/"

# libexec
mkdir -p "${BUILD_ROOT}/${_cap_home}/libexec"
cp -a libexec/. "${BUILD_ROOT}/${_cap_home}/libexec/"

# docs
mkdir -p "${BUILD_ROOT}/${_cap_home}/share/doc"
cp -a doc/. "${BUILD_ROOT}/${_cap_home}/share/doc/"

# man pages
mkdir -p "${BUILD_ROOT}/usr/share/man/man1"
gzip -c doc/deploy.1 > "${BUILD_ROOT}/usr/share/man/man1/deploy.1.gz"

# etc
mkdir -p "${BUILD_ROOT}/${_cap_home}/etc"
cp -a etc/. "${BUILD_ROOT}/${_cap_home}/etc/"

#
# softlinks from /usr/*/cap5 -> ${_cap_home}/*
#
mkdir -p "${BUILD_ROOT}/usr/share/doc"
ln -sf "${_cap_home}/share/doc" "${BUILD_ROOT}/usr/share/doc/cap5"
mkdir -p "${BUILD_ROOT}/usr/libexec"
ln -sf "${_cap_home}/libexec" "${BUILD_ROOT}/usr/libexec/cap5"
mkdir -p "${BUILD_ROOT}/usr/src"
ln -sf "${_cap_home}/src" "${BUILD_ROOT}/usr/src/cap5"
mkdir -p "${BUILD_ROOT}/usr/bin"
ln -sf "${_cap_home}/bin/deploy" "${BUILD_ROOT}/usr/bin/deploy"

#
# setup profile links or paths
#
mkdir -p "${BUILD_ROOT}/etc/profile.d"
if [[ "${_cap_home}" != "." ]]; then
    sed -i.bak -e "s!INSERT_CAPHOME_HERE!SYSTEM!g" \
        "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh"
    rm -f "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh.bak"
    sed -i.bak -e "s!INSERT_CAPHOME_HERE!SYSTEM!g" \
        "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh"
    rm -f "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh.bak"
    ln -sf "${_cap_home}/etc/profile.d/cap.sh"  "${BUILD_ROOT}/etc/profile.d/cap.sh"
    ln -sf "${_cap_home}/etc/profile.d/cap.csh" "${BUILD_ROOT}/etc/profile.d/cap.csh"
else
    sed -i.bak -e "s!INSERT_CAPHOME_HERE!${BUILD_ROOT}!g" \
        "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh"
    rm -f "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh.bak"
    sed -i.bak -e "s!INSERT_CAPHOME_HERE!${BUILD_ROOT}!g" \
        "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh"
    rm -f "${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh.bak"
fi
