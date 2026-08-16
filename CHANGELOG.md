# Changelog

All notable changes to CAP are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Changed
- `src/make.def`: removed `wget --no-check-certificate` and `curl -k` — downloads no longer disable TLS certificate verification
- Synced project-status wording ("preserved, not revived") across `README.md`, `cap.spec` `%description`, and `debian/DEBIAN/control` `Description:`
- Replaced dead/misdirected contact metadata (`www.capforge.org`, `*_AT_lists_DOT_sf_DOT_net` addresses — the `capforge.org` domain and the SourceForge `cap` project now belong to unrelated third parties) with the GitHub repo URL and a `users.noreply.github.com` maintainer address
- Corrected `cap.spec` `%changelog`: the `5.0.0` modernization entry had been mislabelled as CAP4 `4.1-1`

### Added
- `src/README.md`: documents that tool recipes under `src/` are a historical 2012 snapshot; most upstream URLs are dead; explains how to build a tool by supplying your own source tarball
- `doc/cfunc.3`: manpage for the `cfunc` shared function library (`cprint`, `parsecli`, `check_validvar`, `pkg_search`, `make_tool`)
- `bats` CI job (`ci.yml`), matrixed across Ubuntu and macOS — the test suite now actually runs in CI
- Release workflow signs with a passphrase-protected GPG key (`secrets.GPG_PASSPHRASE`, `--pinentry-mode loopback --passphrase-file`, cleanup step)

### Security
- Release workflow's GPG signing key was regenerated with a passphrase after the previous key (empty passphrase) was found insufficiently protected for a key with GitHub Actions secret-store access

---

## [5.0.0] — 2026-07-13

### Added
- Renamed project CAP4 → CAP5; pre-modernization state preserved as git tag `cap4`
- `.shellcheckrc`, `GNUmakefile` (`lint`, `test`, `install-hooks` targets), `.editorconfig`
- `tests/`: bats test suite for `cfunc` functions and `install.sh` behavior
- `hooks/pre-commit`: runs shellcheck on staged shell files
- `doc/deploy.1`: manpage for the `deploy` CLI
- `.github/workflows/ci.yml`: shellcheck on Linux and macOS
- `.github/workflows/release.yml`: tag-triggered build, GPG-sign, and publish RPM + DEB
- `packaging/RPM-GPG-KEY-cap5`: GPG public key for RPM signature verification

### Changed
- `libexec/sh/cfunc`, `deploy`, `install.sh`, `build-cap5.sh`: `set -euo pipefail`, quoted expansions, portable long-option parsing (replaces GNU-only `getopt`), `cp -a` / `sed -i.bak` in place of GNU-only flags, `mktemp -d` for scratch directories
- `cap.spec`: `%autosetup`, `%{buildroot}`, removed obsolete `BuildRoot:`/`%clean`
- `debian/DEBIAN/control`: package renamed `cap` (was `cap-4.1`, violating Debian policy §5.6.1), `Priority: optional`, explicit `Depends:`

### Fixed
- `deploy`/`libexec/sh/cfunc`: ambiguous `||`/`&&` chains in the cfunc-sourcing guard and `make_tool` path resolution
- Silent-failure sites in `build-cap5.sh`: `maketgz()` output variables and `git describe` result are now asserted non-empty rather than trusted implicitly

---

## [4.1] and earlier

Pre-modernization CAP4 history is preserved at git tag `cap4` and is not
individually itemized here.

[Unreleased]: https://github.com/cdmaestas/cap/compare/v5.0.0...HEAD
[5.0.0]: https://github.com/cdmaestas/cap/releases/tag/v5.0.0
