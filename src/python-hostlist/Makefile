include ../make.def

VERSION=1.13
SRC=python-hostlist-$(VERSION)
TAR=$(SRC).tar.gz
URL="http://www.nsc.liu.se/~kent/python-hostlist/$(TAR)"

include ../make.workbench

.configure-$(SRC): $(TAR)
	$(call untar-src,"$(TAR)")
	$(call link-src,"$(SRC)")
	touch $@

.make-$(SRC): .configure-$(SRC)
	$(call print-header,"cap4 src make $(SRC)")
	cd src && python setup.py build > .make-$(SRC) 2>&1
	touch $@

install: .make-$(SRC)
	$(call print-header,"cap4 src install $(SRC)")
	cd src && python setup.py install --prefix=$(PREFIXDIR)/$(SRC) >> .make-$(SRC) 2>&1
