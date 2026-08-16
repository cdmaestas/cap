# src/ — tool recipes (historical)

Each subdirectory here is a Makefile-based recipe for building one HPC
cluster tool (pdsh, genders, slurm, munge, conman, freeipmi, powerman,
and others), driven through `deploy` and the shared macros in
[`make.def`](make.def).

**Status: preserved as-is, not maintained as working downloads.**

These recipes date to CAP4 (2012). Most of the `URL=` lines point at
hosts that no longer serve the referenced tarball:

- `*.googlecode.com` — Google Code shut down in 2016.
- `github.com/downloads/...` — GitHub removed the legacy Downloads
  feature in 2013.
- `*.svn.sourceforge.net` — SourceForge's SVN hosting for this project
  is gone; the `cap` and `capforge` namespaces on SourceForge now
  belong to unrelated projects.

A handful still resolve (`ftp.gnu.org`, `schedmd.com`, GitHub release
tarballs) because the upstream project is still active, but none of
these URLs have been re-verified against original checksums.

## If you want to actually build one of these tools

Don't rely on the recipe's `URL=` line. Instead:

1. Find the tool's current upstream (its own project page, not the
   URL recorded here) and download the source yourself.
2. Place the tarball in the tool's `src/<tool>/` directory under the
   filename the Makefile's `TAR=` variable expects.
3. Run `deploy --tool <toolname> --prefix DIR` (skips the download
   step once the tarball is already present) or invoke `make` directly
   in that directory.

The recipes' build logic (configure flags, patches, install steps) is
what's preserved and maintained here — the download URLs are kept
as a historical record of where these tools lived in 2012, not as a
live index.
