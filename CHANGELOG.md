# Changelog

All notable changes to CAP are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Changed
- Removed debug diagnostics (`ar t`, `debsigs --list`) added while chasing the `5.0.3` DEB-signing bugs, now that the root causes are fixed and confirmed

---

## [5.0.3] — 2026-08-17

### Changed
- DEB signing migrated from `dpkg-sig` to `debsigs` + `debsig-verify` — `dpkg-sig` is dead upstream, dropped from Debian's own archive past `bullseye` and never packaged for Ubuntu 24.04

### Fixed
- `debsigs --verify` is unimplemented in the Ubuntu-packaged version (`"Verify not yet implemented."`, confirmed by reading its source) — the release workflow and README now call `debsig-verify` directly, which the manpage confirms is the real verifier `debsigs --verify` is documented to wrap
- `debsigs`' Perl regex for detecting the control/data archive members doesn't recognize `.zst` (`/^control\.tar(?:\.gz|\.xz)?$/`), so it silently signed an incomplete concatenation against a modern zstd-compressed `.deb` instead of erroring; `build-cap5.sh` now forces `-Zgzip` on `dpkg-deb --build`, which both tools' member-detection logic agrees on
- GPG defaults to a SHA1 digest for `debsigs`' bare `gpg --detach-sign` call regardless of the signing key's own stated preferences (confirmed by reproducing locally and inspecting the signature packet), and Ubuntu's `gpg` refuses to verify SHA1 signatures at all — forced via `digest-algo SHA256` in `gpg.conf`, since `debsigs`' `--gpgopts` flag is parsed but never actually reaches its signing call

### Added
- `packaging/cap5-debsig-policy.pol`: committed `debsig-verify` policy file (mirrors the `packaging/RPM-GPG-KEY-cap5` convention); the release workflow asserts its fingerprint matches the currently-imported signing key before using it, so a future key rotation fails loudly instead of silently signing against a stale policy

---

## [5.0.2] — 2026-08-16

### Fixed
- CI shellcheck failure: `build-cap5.sh`'s `git_version()` used the `A && B || true` idiom, which Ubuntu's apt-installed shellcheck (pinned at 0.9.0) flags as `SC2015`; the locally-used Homebrew shellcheck (0.11.0) added a leniency exception for exactly that `|| true` pattern, so it passed locally while breaking on CI's older toolchain. Rewritten as an explicit `if`/`then`/`else`
- 12 of the tool recipes under `src/` pointed at fully dead hosts with a verifiable, working replacement: 11 `*.googlecode.com` URLs (conman, diskscrub, io-watchdog, munge, nfsroot, nodediag, padb, pdsh, powerman, slurm-spank-plugins, sqlog) now point at Google's official archive (`storage.googleapis.com/google-code-archive-downloads/`), each individually confirmed to serve the exact filename the recipe expects; `clustershell` now points at its real current home (`clustershell/clustershell`, moved from `cea-hpc/clustershell`), with its `TAR` filename convention adjusted to match GitHub's actual tag-archive naming rather than the old `googlecode`-era convention

---

## [5.0.1] — 2026-08-16

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

### Fixed
- `cap.spec`'s `Source0` basename (`v%{version}.tar.gz`, a GitHub tag-archive URL) didn't match the tarball `build-cap5.sh` actually produces (`cap-%{version}.tar.gz`), breaking the RPM build's `%prep` step; restored the `%{name}-%{version}.tar.gz` pattern and made the URL genuinely fetchable by publishing that exact tarball as a release asset

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

[Unreleased]: https://github.com/cdmaestas/cap/compare/v5.0.3...HEAD
[5.0.3]: https://github.com/cdmaestas/cap/compare/v5.0.2...v5.0.3
[5.0.2]: https://github.com/cdmaestas/cap/compare/v5.0.1...v5.0.2

<!-- v5.0.0's tag and release were pruned by the "keep newest 3" retention
     policy once v5.0.3 shipped; the commit it pointed to is still reachable
     on main, so these link to it directly instead of a now-404ing tag. -->
[5.0.1]: https://github.com/cdmaestas/cap/compare/597bee8...v5.0.1
[5.0.0]: https://github.com/cdmaestas/cap/commit/597bee8669b79efeeace55955ae7c5a14f1a296e
