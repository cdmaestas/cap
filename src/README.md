# src/ — tool recipes

Each subdirectory here is a Makefile-based recipe for building one HPC
cluster tool (pdsh, genders, slurm, munge, conman, freeipmi, powerman,
and others), driven through `deploy` and the shared macros in
[`make.def`](make.def).

**Status: build logic preserved and maintained; download URLs are a mix
of working and historical — see below for which is which.**

These recipes date to CAP4 (2012). Every `URL=` line has been checked
against the live host (2026-08-16), not assumed.

## Working — updated to a verified current source

Twelve recipes pointed at hosts that are fully gone. Where a real
replacement exists, the `URL=` line was updated and the exact expected
file was confirmed to download successfully:

- `conman`, `diskscrub`, `io-watchdog`, `munge`, `nfsroot`, `nodediag`,
  `padb`, `pdsh`, `powerman`, `slurm-spank-plugins`, `sqlog` —
  `*.googlecode.com` is dead, but Google preserved the original release
  files at `storage.googleapis.com/google-code-archive-downloads/`.
  Each project's exact expected filename was confirmed present there.
- `clustershell` — the old `github.com/downloads/...` URL (GitHub
  killed that feature in 2013) is replaced with a real GitHub tag
  archive. Note: the repo itself moved from `cea-hpc/clustershell` to
  `clustershell/clustershell`, and GitHub's archive basename is
  `v$(VERSION).tar.gz`, not `$(SRC).tar.gz` — see the comment in
  `clustershell/Makefile` before "fixing" this to match the other
  recipes' pattern.

## Still historical — dead or unverified, left untouched

- `environment-modules` — points at `pkgs.repoforge.org`; RepoForge is
  fully gone and the bare domain now resolves to an unrelated GitHub
  Pages site. No replacement found.
- `onesis` — points at SourceForge SVN hosting. The project page
  redirects fine, but that doesn't confirm the `svn co` protocol
  endpoint itself still works; not verified either way.
- `torque` (adaptivecomputing.com) and `slurm` (schedmd.com) — both
  hosts return 200, but that confirms the page loads, not that this
  specific tarball is still served under this exact filename. Treat as
  unverified, not confirmed dead.

Everything else (`ftp.gnu.org`, SourceForge file downloads for
`collectl`, `collectl-utils`, `modules`, `genders`, `gendersllnl`,
`nsc.liu.se`) was already live and unchanged.

## If a URL doesn't work

Don't assume the recipe is broken by design — check this file first,
since a fix may already exist upstream that hasn't been re-verified
here. Otherwise:

1. Find the tool's current upstream yourself.
2. Place the tarball in the tool's `src/<tool>/` directory under the
   filename the Makefile's `TAR=` variable expects.
3. Run `deploy --tool <toolname> --prefix DIR` (skips the download
   step once the tarball is already present) or invoke `make` directly
   in that directory.
