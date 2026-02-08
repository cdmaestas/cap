#!/bin/sh
#set -x
################################################################################
# Name:         build-cap4
# File:         build-cap4.sh
# Purpose:      Build the cap4 distribution (rpm|deb|tgz)
# Bug Reports:  cap4-devel_AT_lists_DOT_sf_DOT_net
#
# Last Modified:
# $Id: cap-program-template 1349 2009-01-28 16:09:23Z jatencio $
#
# Copyright:
# © Copyright 2012 Hewlett-Packard Development Company, L.P
#
# License: GPL v2
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
################################################################################

if [ -z $CAP4DEVHOME ]; then
	echo "Define CAP4DEVHOME!"
	exit 1
fi
if [ $# -ne 2 ]; then
	echo "$0 official|snapshot rpm|srpm|deb|tgz"
	exit 1
fi
PKGTYPE=$1
PKG=$2

VERSION=$(grep ^Version: $CAP4DEVHOME/cap.spec | awk '{print $2}')

#
# BEGIN: get source versions from repo
#
git_version() {
   GITVERSION=`git describe --always`
   GITMODIFIED=`(git status | grep "modified:\|added:\|deleted:" -q) && echo "_M"`
   RELEASE=$GITVERSION$GITMODIFIED
}
svnversion() {
	RELEASE=$(svnversion $CAP4DEVHOME |  cut -f2 -d ":")
}
#
# END: get source versions from repo
#

# determine the package type
if [ $PKGTYPE = snapshot ]; then
	[ -d .svn ] && [ "x$RELEASE" = "x" ] && svnversion
	[ -d .git ] && [ "x$RELEASE" = "x" ] && git_version
	REL_SEDCMD="s/RELEASE/1_${RELEASE}/g"
elif [ $PKGTYPE = official ]; then
	REL_SEDCMD="s/RELEASE/1/g"
else
	echo "$0 $PKGTYPE is not supported at this time"
	exit 1
fi


#
# helper maketgz function
#
maketgz() {
        DISTRO=$1
	SEDCMD="s/$(echo $CAP4DEVHOME  | sed 's/\//\\\//g')//g"
	[ -d .svn ] && EXCLUDE=$(for file in $(svn stat $CAP4DEVHOME | sed $SEDCMD | grep "?" | awk '{print $2}'); do echo -n " --exclude $file"; done)
	BASE_DIR=cap-${VERSION}
	SOURCE_BASE_DIR=/tmp/cap4_src_work
	if [ -d ${SOURCE_BASE_DIR} ]; then
		rm -fr $SOURCE_BASE_DIR
	fi
	mkdir -p $SOURCE_BASE_DIR
	SOURCE_BUILD_ROOT=${SOURCE_BASE_DIR}/${BASE_DIR}
	rsync -a --exclude '*.svn' --exclude '*.git' $EXCLUDE --delete $CAP4DEVHOME/ ${SOURCE_BUILD_ROOT}

	sed ${REL_SEDCMD} $CAP4DEVHOME/cap.spec > ${SOURCE_BUILD_ROOT}/.spec

	cd ${SOURCE_BUILD_ROOT} && rm -f build-cap4.sh cap.spec Makefile git.setup
	if [ "x$DISTRO" != "xdebian" ]; then
	    rm -rvf ${SOURCE_BUILD_ROOT}/debian
	fi
	cd ${SOURCE_BASE_DIR}
	if [ $PKGTYPE != official -a $PKG = tgz ]; then
		DIST_TGZ=${BASE_DIR}-${RELEASE}.tar.gz
	else
		DIST_TGZ=${BASE_DIR}.tar.gz
	fi
	tar -zcf ${DIST_TGZ} ${BASE_DIR}
}


if [ $PKG = rpm -o $PKG = srpm ]; then
	maketgz
	if [ `id -u` -ne 0 ]; then
		if [ ! -f $HOME/.rpmmacros ]; then
			cat << EOF > $HOME/.rpmmacros
%_topdir /home/${USER}/redhat
EOF
			mkdir -p $HOME/redhat
			mkdir -p $HOME/redhat/{BUILD,RPMS,SOURCES,SPECS,SRPMS,tmp}
		fi
	fi
	if [ $PKG = srpm ]; then
		rpmbuild -ts ${SOURCE_BASE_DIR}/${DIST_TGZ}
	else
		rpmbuild -tb ${SOURCE_BASE_DIR}/${DIST_TGZ}
	fi
elif [ $PKG = deb ]; then
	maketgz debian
	if [ -d /tmp/cap4-debian ]; then
		rm -fr /tmp/cap4-debian
	fi
	mkdir -p /tmp/cap4-debian
	cd $CAP4DEVHOME
	$CAP4DEVHOME/install.sh /tmp/cap4-debian
	cd ${SOURCE_BUILD_ROOT}
	cp -r debian/DEBIAN /tmp/cap4-debian
	sed ${REL_SEDCMD} $CAP4DEVHOME/debian/DEBIAN/control > /tmp/cap4-debian/DEBIAN/control
	cd /tmp
	if [ -z $RELEASE ]; then
		DIST_DEB=cap-${VERSION}-1.deb
	else
		DIST_DEB=cap-${VERSION}-1_${RELEASE}.deb
	fi
	dpkg -b /tmp/cap4-debian ${DIST_DEB}
	rm -fr /tmp/cap4-debian
	mv -f /tmp/${DIST_DEB} $CAP4DEVHOME
	echo "$PKGTYPE cap4 $PKG located in ${CAP4DEVHOME}/${DIST_DEB}"
elif [ $PKG = tgz ]; then
	maketgz
	cp -f ${SOURCE_BASE_DIR}/${DIST_TGZ} $CAP4DEVHOME
	echo "$PKGTYPE cap4 $PKG located in ${CAP4DEVHOME}/${DIST_TGZ}"
else 
	echo "$0 $PKG is not supported at this time"
	exit 1
fi

# copy stuff

# cleanup any leftovers
rm -rf ${SOURCE_BASE_DIR}

