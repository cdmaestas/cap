#############################################################################
# Name:		cap.sh
# File:		cap.sh
# Purpose:	profile script for cap (sh, ksh and bash style)
# Bug Reports:	cap5-devel_AT_lists_DOT_sf_DOT_net
#
# Last Modified:
# $Id: cap.sh 1054 2007-09-05 13:48:25Z cashmont $
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

# if cap is installed in system level directories, it should be in our path already,
CAPHOME=INSERT_CAPHOME_HERE
if [[ "${CAPHOME}" != "SYSTEM" ]]; then
    export CAPHOME
    export PATH="${CAPHOME}/bin:${PATH}"
    export MANPATH="${CAPHOME}/man:${MANPATH}"
fi


