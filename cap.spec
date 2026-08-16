# spec file for package CAP5
Name:         cap
Packager:     cdmaestas@users.noreply.github.com
Version:      4.1
Release:      RELEASE
Epoch:        0
BuildArch:    noarch
License:      GPL
Summary:      Cluster Administration Package (build/install framework)
Group:        Productivity/Clustering/Computing
URL:          https://github.com/cdmaestas/cap
Source0:      https://github.com/cdmaestas/cap/releases/download/v%{version}/%{name}-%{version}.tar.gz
Requires:     bash >= 4.0
Requires:     coreutils
Requires:     rsync

# If no cap_home passed in, assume /opt/cap5
%{!?_cap_home: %define _cap_home /opt/cap5}

%description
CAP5 is a build/install framework (deploy, cfunc, and packaging pipeline)
originally built to bundle and deploy common HPC cluster tools (pdsh,
genders, slurm, munge, conman, freeipmi, powerman, and more) through a
single interface.

Project status: preserved, not revived. The framework itself is
maintained and works today. The tool recipes under src/ are a historical
snapshot from 2012; most of their download URLs point at hosts that no
longer exist. See src/README.md in the source distribution for details.

%pre

%prep
%autosetup -n %{name}-%{version}

%build
:

%install
./install.sh %{buildroot} %{_cap_home}

%post
:

%postun

%preun

%files
%defattr(-,root,root)
%{_cap_home}/etc/*
%{_cap_home}/src/*
%{_cap_home}/share/doc/*
%{_cap_home}/bin/*
%{_cap_home}/libexec/*
/usr/share/doc/cap5
/usr/share/man/man1/deploy.1.gz
/usr/share/man/man3/cfunc.3.gz
/usr/libexec/cap5
/usr/src/cap5
/usr/bin/deploy
/etc/profile.d/cap.sh
/etc/profile.d/cap.csh

%changelog
* Mon Jul 13 2026 cdmaestas <cdmaestas@users.noreply.github.com> - 5.0.0-1
- Renamed project CAP4 -> CAP5; preserved pre-modernization state as tag cap4
- Modernized build system and shell scripts for cross-platform (macOS + Linux) compatibility
- Replaced GNU-only tools with portable equivalents (cp -a, portable sed -i, mktemp -d)
- Added shellcheck compliance (.shellcheckrc, CI), bats test suite, and GNUmakefile dev targets
- Updated RPM spec to use modern macros (%autosetup, %{buildroot})
- Added GPG-signed RPM/DEB release pipeline (tag-triggered GitHub Actions workflow)
- Added git pre-commit hook and deploy(1) manpage

* Fri Jun 27 2025 CAP Developers - 4.1-1
- Prior CAP4 development snapshot (see CHANGELOG.md for full history)
