# CAP5 — Cluster Administration Package

CAP5 is a framework that integrates, configures, and manages HPC clusters by bundling and deploying common cluster tools (pdsh, genders, slurm, munge, conman, freeipmi, powerman, and more) through a unified build and install system.

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
2. Builds RPM and DEB packages
3. Signs the RPM with the project GPG key (stored as `secrets.GPG_PRIVATE_KEY`)
4. Verifies the signature against `packaging/RPM-GPG-KEY-cap5`
5. Publishes a GitHub Release with the signed packages and public key

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

**First-time setup:** add the GPG private key as a repository secret named `GPG_PRIVATE_KEY` in GitHub → Settings → Secrets and variables → Actions (same key used in Scale-GUInstall).

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
