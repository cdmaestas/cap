include ../make.def

# check out http://mcelog.org/installation.html

SRC=onesis.svn
URL="https://onesis.svn.sourceforge.net/svnroot/onesis"

default: .make-$(SRC)

svndownload: $(SRC)

$(SRC): 
	$(call print-header,"cap4 src svn checkout $@")
	mkdir -p $(SRC)
	$(call svncheckout-src,$(URL)/trunk,trunk)
	mv trunk $(SRC)/
	$(call svncheckout-src,$(URL)/tools,tools)
	mv tools $(SRC)/
	@touch $@

.make-$(SRC): $(SRC)
	$(call print-header,"cap4 src make $(SRC)")
	@echo "run as root: make -C $(SRC)/trunk svnrpm"
	@touch $@

include ../make.workbench

