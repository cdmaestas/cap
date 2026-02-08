include ../make.def

# check out http://mcelog.org/installation.html

SRC=mcelog.git
URL="git://git.kernel.org/pub/scm/utils/cpu/mce/$(SRC)"

default: .make-$(SRC)

gitdownload: $(SRC)

$(SRC): 
	$(call print-header,"cap4 src git pull $@")
	$(call gitpull-src,$(URL),$(SRC))

.make-$(SRC): $(SRC)
	$(call print-header,"cap4 src make $(SRC)")
	make -C $(SRC) > .make-$(SRC) 2>&1
	@echo "Run as root make install"
	@touch $@

include ../make.workbench

