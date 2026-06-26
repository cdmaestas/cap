# spec file for package CAP (Version 4.1)
Name:         cap
Packager:     cap5-devel_AT_lists_DOT_sf_DOT_net
Version:      4.1
Release:      RELEASE
Epoch:        0
BuildArch:    noarch
License:      GPL
Summary:      Cluster Administration Package
Group:        Productivity/Clustering/Computing
URL:          http://www.capforge.org
Source0:      http://www.capforge.com/downloads/cap/%{name}-%{version}.tar.gz
Requires:     bash >= 4.0
Requires:     coreutils
Requires:     rsync

# If no cap_home passed in, assume /opt/cap5
%{!?_cap_home: %define _cap_home /opt/cap5}

%description
The Cluster Administration Package (CAP) is meant to ease integration,
configuration, and systems management for clustering. It is the "glue"
that allows cluster administrators to leverage existing technologies
in a functional framework. This is done by delivering functionality
into three component categories.

The first is "Information Management." From this category functions
can be written to generate standard unix configuration files or to
produce a file arrangement suitable for other clustering technologies.

The next category is "Control." This category allows an administrator
to control their cluster as one system using common methods one uses to
control a single system, such as power and console. With the addition of
management devices, a cluster administrator can also control uids or
gather system sensor data when possible.

The last category is "Installation." When installing a multitude of
systems a cluster administrator wants a common method or set of methods
to ensure a set of functionality if delivered to each node in their
cluster. By leveraging existing technologies, CAP can ensure it can adapt
to fit the needs of other installation methods available.

Authors:
--------
    CAPforge.org

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
/usr/libexec/cap5
/usr/src/cap5
/usr/bin/deploy
/etc/profile.d/cap.sh
/etc/profile.d/cap.csh

%changelog
* Fri Jun 27 2025 CAP Developers <cap5-devel@sf.net> - 4.1-1
- Modernized build system and shell scripts for cross-platform compatibility
- Replaced GNU-only tools with portable equivalents (cp -a, portable sed -i)
- Added shellcheck compliance and bats test suite
- Updated RPM spec to use modern macros (%autosetup, %{buildroot})
