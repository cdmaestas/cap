SHELL := bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

SHELL_SCRIPTS := $(shell find . \
    -not -path './.git/*' \
    -not -path './src/*' \
    \( -name '*.sh' -o -name 'cfunc' -o -name 'deploy' \) \
    | sort)

.PHONY: help lint test install dist tgz rpm srpm deb gittgz gitrpm gitsrpm gitdeb

help:
	@echo "Targets:"
	@echo "  lint     Run shellcheck on all shell scripts"
	@echo "  test     Run bats test suite"
	@echo "  install  Install cap5 (delegates to Makefile)"
	@echo "  dist     Build distribution tarball"

lint:
	shellcheck --rcfile .shellcheckrc $(SHELL_SCRIPTS)

test:
	bats tests/

install dist tgz rpm srpm deb gittgz gitrpm gitsrpm gitdeb:
	$(MAKE) -f Makefile $@
