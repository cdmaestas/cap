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

Run shellcheck on all scripts:
```sh
make lint
```

Run the bats test suite:
```sh
make test
```

## Packaging

Build a release tarball:
```sh
export CAP4DEVHOME=$(pwd)
./build-cap5.sh official tgz
```

Build a snapshot RPM from the current git state:
```sh
./build-cap5.sh snapshot rpm
```

Build a Debian package:
```sh
./build-cap5.sh official deb
```

## Directory Layout

```
cap/
├── deploy               # Main entry point — builds/installs a tool
├── install.sh           # Copies files into a build root
├── build-cap5.sh        # Produces rpm/deb/tgz distribution archives
├── Makefile             # install / dist / tgz / rpm targets
├── GNUmakefile          # Developer targets: lint, test
├── cap.spec             # RPM spec
├── debian/DEBIAN/       # Debian packaging metadata
├── etc/profile.d/       # Shell profile scripts (cap.sh, cap.csh)
├── libexec/sh/cfunc     # Bash function library sourced by deploy
├── src/                 # Per-tool Makefiles (pdsh, genders, slurm, …)
├── doc/                 # Documentation and license files
└── tests/               # bats test suite
```

## License

GPL v2 — see [doc/GPL_V2](doc/GPL_V2).
© Copyright 2006, 2007, 2012 Hewlett-Packard Development Company, L.P.
