# CAP5 — Cluster Administration Package

CAP5 is a build/install framework — `deploy`, `cfunc`, and the packaging
pipeline — originally built to bundle and deploy common HPC cluster tools
(pdsh, genders, slurm, munge, conman, freeipmi, powerman, and more) through
a single interface.

**Project status: preserved, not revived.** The framework itself
(`deploy`, `libexec/sh/cfunc`, packaging, CI) is maintained and works today.
The tool recipes under [`src/`](src/README.md) are a historical snapshot
from 2012 — most of their download URLs point at hosts that no longer
exist (Google Code, legacy GitHub Downloads, dead SourceForge projects).
Running `deploy --tool <name>` today will not fetch a working tarball for
most tools unless you supply the source yourself. See
[`src/README.md`](src/README.md) for details.

## Prerequisites

| Tool | Purpose |
|---|---|
| bash >= 4.0 | Required by all scripts |
| make | Build orchestration |
| rsync | Used by install.sh and build-cap5.sh |
| shellcheck | Linting (dev only) |
| bats | Testing (dev only) |
| rpmbuild | RPM packaging (optional) |
| dpkg-deb | Debian packaging (optional) |

## Quick Start

```sh
git clone <repo>
cd cap
export CAPHOME=$(pwd)
make install prefix=/opt/cap5
source /opt/cap5/etc/profile.d/cap.sh
```

## Deploy Usage

Build and install a tool as RPM packages:
```sh
deploy --tool slurm --rpm
deploy --tool pdsh --rpm --clean
```

Install a tool to a prefix directory:
```sh
deploy --tool pdsh --prefix /opt/cap5
deploy --tool genders --prefix /opt/cap5 --clean
```

Available flags:
- `--tool TOOLNAME` — name of the tool directory under `src/`
- `--rpm` — build and install as RPM
- `--prefix DIR` — install to this directory prefix
- `--clean` — run `make clean` before build
- `--distclean` — run `make distclean` before build
- `--debug` / `--verbose` — enable debug output

## Development

Install the git pre-commit hook (runs shellcheck on staged shell files):
```sh
make install-hooks
```

Run shellcheck on all scripts:
```sh
make lint
```

Run the bats test suite:
```sh
make test
```

A manpage for `deploy` is installed to `/usr/share/man/man1/deploy.1.gz`:
```sh
man deploy
```

## Packaging

Build packages locally:
```sh
export CAP5DEVHOME=$(pwd)
./build-cap5.sh official tgz   # tarball
./build-cap5.sh official rpm   # RPM
./build-cap5.sh official deb   # Debian package
./build-cap5.sh snapshot rpm   # snapshot RPM from current git state
```

## Releases

Pushing a `v*.*.*` tag triggers the release workflow, which:
1. Patches the version into `cap.spec` and `debian/DEBIAN/control` from the tag
2. Builds a source tarball, RPM, and DEB package
3. Signs the RPM (`rpmsign`) and DEB (`debsigs`) with the project GPG key (stored as `secrets.GPG_PRIVATE_KEY` / `secrets.GPG_PASSPHRASE`)
4. Verifies both signatures against `packaging/RPM-GPG-KEY-cap5`
5. Publishes a GitHub Release with the signed packages, source tarball, and public key

**To create a release:**
```sh
git tag v5.0.0
git push origin v5.0.0
```

**To verify a downloaded RPM:**
```sh
rpm --import packaging/RPM-GPG-KEY-cap5
rpm --checksig cap-5.0.0-1.noarch.rpm
```

**To verify a downloaded DEB** (requires the `debsig-verify` package — `dpkg-sig` was dropped from Debian/Ubuntu and is no longer usable):
```sh
gpg --export CFBEEA09EFAB240DB5ADE97EA659912A9EBD149C > /tmp/debsig.gpg
sudo install -D -m 644 /tmp/debsig.gpg \
  /usr/share/debsig/keyrings/CFBEEA09EFAB240DB5ADE97EA659912A9EBD149C/debsig.gpg
sudo install -D -m 644 packaging/cap5-debsig-policy.pol \
  /etc/debsig/policies/CFBEEA09EFAB240DB5ADE97EA659912A9EBD149C/generic.pol
debsig-verify cap-5.0.0-1.deb
```
(The public key itself must already be imported into your GPG keyring — `gpg --import packaging/RPM-GPG-KEY-cap5` first if you haven't.)

**First-time setup:** add the GPG private key as a repository secret named `GPG_PRIVATE_KEY`, and its passphrase as `GPG_PASSPHRASE`, in GitHub → Settings → Secrets and variables → Actions (same key used in Scale-GUInstall). If the signing key is ever rotated, `packaging/cap5-debsig-policy.pol`'s `id=` attributes must be updated to the new fingerprint — the release workflow asserts this rather than silently signing with a mismatched policy.

## Directory Layout

```
cap/
├── deploy               # Main entry point — builds/installs a tool
├── install.sh           # Copies files into a build root
├── build-cap5.sh        # Produces rpm/deb/tgz distribution archives
├── Makefile             # install / dist / tgz / rpm targets
├── GNUmakefile          # Developer targets: lint, test, install-hooks
├── cap.spec             # RPM spec
├── debian/DEBIAN/       # Debian packaging metadata
├── packaging/           # GPG public key for package verification
├── hooks/               # Git hook scripts (install with make install-hooks)
├── etc/profile.d/       # Shell profile scripts (cap.sh, cap.csh)
├── libexec/sh/cfunc     # Bash function library sourced by deploy
├── src/                 # Per-tool Makefiles (pdsh, genders, slurm, …)
├── doc/                 # Documentation, license, and deploy.1 manpage
└── tests/               # bats test suite
```

## License

GPL v2 — see [doc/GPL_V2](doc/GPL_V2).
© Copyright 2006, 2007, 2012 Hewlett-Packard Development Company, L.P.
