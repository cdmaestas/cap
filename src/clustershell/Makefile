include ../make.def

VERSION=1.6
SRC=clustershell-$(VERSION)
# clustershell was transferred from cea-hpc/clustershell to clustershell/clustershell;
# GitHub's tag-archive basename is v$(VERSION).tar.gz, not $(SRC).tar.gz, but it
# extracts to $(SRC)/ as expected (verified 2026-08-16).
TAR=v$(VERSION).tar.gz
URL="https://github.com/clustershell/clustershell/archive/refs/tags/$(TAR)"

include ../make.workbench

.make-$(SRC): download
	$(call untar-src,"$(TAR)")
	$(call link-src,"$(SRC)")

install: .make-$(SRC)
	cd src && python setup.py install --prefix=$(PREFIXDIR)
