#!/bin/bash
############################################################################ 
# Name:		install
# File:		install.sh
# Purpose:	install cap to build root directory
# Bug Reports:	cap4-devel_AT_lists_DOT_sf_DOT_net
#
# Last Changed:
# $Id: install.sh 1138 2007-11-12 16:32:33Z jatencio $
#
# Copyright:
# © Copyright 2006, 2007, 2012 Hewlett-Packard Development Company, L.P
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
############################################################################ 

#set -x
BUILD_ROOT=$1

# place stuff in /opt/cap4 and softlink to it from standard space instead
_cap_home=$2

[ $# -lt 1 ] && echo "$0 BUILD_ROOT _cap_home" && exit 1
[ "x${_cap_home}" = "x" ] && _cap_home=/opt/cap4

# bins 
mkdir -p ${BUILD_ROOT}/${_cap_home}/bin
cp -rp --preserve=link deploy  ${BUILD_ROOT}/${_cap_home}/bin/

# src 
mkdir -p ${BUILD_ROOT}/${_cap_home}/src
cp -rp --preserve=link src/*  ${BUILD_ROOT}/${_cap_home}/src/

# libexec
mkdir -p ${BUILD_ROOT}/${_cap_home}/libexec
cp -rp --preserve=link libexec/*  ${BUILD_ROOT}/${_cap_home}/libexec/

# docs 
mkdir -p ${BUILD_ROOT}/${_cap_home}/share/doc
cp -rp --preserve=link doc/*  ${BUILD_ROOT}/${_cap_home}/share/doc/

# etc
mkdir -p ${BUILD_ROOT}/${_cap_home}/etc
cp -rp --preserve=link etc/*  ${BUILD_ROOT}/${_cap_home}/etc/

#
# softlinks from /usr/*/cap4 -> ${_cap_home}/*
#
mkdir -p ${BUILD_ROOT}/usr/share/doc
ln -sf ${_cap_home}/share/doc ${BUILD_ROOT}/usr/share/doc/cap4
mkdir -p ${BUILD_ROOT}/usr/libexec
ln -sf ${_cap_home}/libexec ${BUILD_ROOT}/usr/libexec/cap4
mkdir -p ${BUILD_ROOT}/usr/src
ln -sf ${_cap_home}/src ${BUILD_ROOT}/usr/src/cap4
mkdir -p ${BUILD_ROOT}/usr/bin
ln -sf ${_cap_home}/bin/deploy ${BUILD_ROOT}/usr/bin/deploy
#
# setup profile links or paths
#
mkdir -p ${BUILD_ROOT}/etc/profile.d
if [ ${_cap_home} != "." ]; then
	sed -i -e "s!INSERT_CAPHOME_HERE!SYSTEM!g" ${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh
	sed -i -e "s!INSERT_CAPHOME_HERE!SYSTEM!g" ${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh
	ln -sf ${_cap_home}/etc/profile.d/cap.sh ${BUILD_ROOT}/etc/profile.d/cap.sh
	ln -sf ${_cap_home}/etc/profile.d/cap.csh ${BUILD_ROOT}/etc/profile.d/cap.csh
else
	sed -i -e "s!INSERT_CAPHOME_HERE!${BUILD_ROOT}!g" ${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.csh
	sed -i -e "s!INSERT_CAPHOME_HERE!${BUILD_ROOT}!g" ${BUILD_ROOT}/${_cap_home}/etc/profile.d/cap.sh
fi

