# Contributing to CAP5

## Code Style

**Shell scripts** — all scripts must pass `make lint` (shellcheck) before merging.

- Shebang: `#!/usr/bin/env bash`
- Strict mode at the top of every script: `set -euo pipefail`
- Use `[[ ]]` instead of `[ ]`
- Use `$(...)` instead of backticks
- Quote all variable expansions: `"${VAR}"`
- Use `printf` instead of `echo -e`
- Avoid GNU-only flags (e.g. `cp --preserve=link`, `sed -i` without suffix) — the codebase targets macOS and Linux

See [.shellcheckrc](.shellcheckrc) and [.editorconfig](.editorconfig) for the full ruleset.

## Adding a New Tool

1. Create `src/<toolname>/Makefile` following the pattern in `src/make.def` and `src/make.workbench`.
2. Add `<toolname>` to `TOOLDIRS` in `src/Makefile` (or `OTHERS` for optional tools).
3. Verify `deploy --tool <toolname> --prefix /tmp/test` works end-to-end.
4. Add a bats test in `tests/` if the tool introduces new `cfunc` functions.

## Testing

Run the full test suite before submitting:

```sh
make lint    # shellcheck
make test    # bats
```

Tests live in `tests/test_cfunc.bats` and `tests/test_install.bats`. Add a test for any new function in `libexec/sh/cfunc`.

## Commit Conventions

- Imperative subject line, 72 characters max
- Body explains *why*, not *what*
- Reference issues or mailing list threads where relevant

## Submitting Changes

1. Fork the repository and create a branch.
2. Make your changes and ensure `make lint` and `make test` pass.
3. Open a pull request against `main` with a description of the change and how to test it.
