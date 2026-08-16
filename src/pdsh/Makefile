include ../make.def

VERSION=2.29
SRC=pdsh-$(VERSION)
TAR=$(SRC).tar.bz2
URL="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdsh/$(TAR)"

include ../make.workbench

.configure-$(SRC): $(TAR)
	$(call untar-src,"$(TAR)")
	$(call link-src,"$(SRC)")
	$(call configure-src,$(SRC),--prefix=$(PREFIXDIR)/$(SRC) --without-rsh --with-ssh --with-exec)
	touch $@

.make-$(SRC): .configure-$(SRC)
	$(call make-src,$(SRC))
	touch $@

install: .make-$(SRC)
	$(call make-src-install,$(SRC))
