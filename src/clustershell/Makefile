include ../make.def

VERSION=1.6
SRC=clustershell-$(VERSION)
TAR=$(SRC).tar.gz
URL="https://github.com/downloads/cea-hpc/clustershell/$(TAR)"

include ../make.workbench

.make-$(SRC): download
	$(call untar-src,"$(TAR)")
	$(call link-src,"$(SRC)")

install: .make-$(SRC)
	cd src && python setup.py install --prefix=$(PREFIXDIR)
