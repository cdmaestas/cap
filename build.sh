#!/bin/bash
############################################################################ 
# Name:		build
# File:		build.sh
# Purpose:	build perl doc man pages
# Bug Reports:	cap4-devel_AT_lists_DOT_sf_DOT_net
#
# Last Changed:
# $Id: build.sh 1138 2007-11-12 16:32:33Z jatencio $
#
# Copyright:
# © Copyright 2006, 2007,2012 Hewlett-Packard Development Company, L.P
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

BUILD_ROOT=$1
exit

# Build the man pages commands
#find usr/bin usr/sbin -type f -exec perldoc -d{}.1 -oman {} \;
#find usr/bin usr/sbin -type f -name *.1 -exec gzip -9 {} \;

#
# change permissions properly
#
#find usr/bin usr/sbin usr/libexec/drivers -exec chmod a+rx {} \;
#mkdir -p usr/share/man/man1 
#mv usr/bin/*.gz usr/sbin/*.gz usr/share/man/man1

# Build the man pages perl modules and cli drivers
#find usr/libexec -name '*.p?' -exec perldoc -d{}.3 -oman {} \;

# move libexec drivers to man3
#mkdir -p usr/share/man/man3
#find usr/libexec -name '*.3' -exec gzip -9 {} \;
#find usr/libexec -name '*.gz' -exec mv {} usr/share/man/man3/ \; -print

