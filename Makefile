#
# developer Makefile for cap4
#

prefix        ?= /opt/cap4

install:
	@echo "Installing cap4 in $(prefix)"
	@export CAP4DEVHOME=`pwd`; ./install.sh $(prefix) .

dist: tgz
svndist: svntgz

tgz rpm srpm deb: build-cap4.sh
	@echo "Building official cap4 $@"
	@export CAP4DEVHOME=`pwd`; ./build-cap4.sh official $@

gittgz svntgz gitrpm svnrpm gitsrpm svnsrpm gitdeb svndeb: build-cap4.sh
	@echo "Building snapshot cap4 $@"
	export CAP4DEVHOME=`pwd` && ./build-cap4.sh snapshot $(shell echo $@ | sed -e 's/svn//g' -e 's/git//g')

