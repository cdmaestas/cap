# spec file for package CAP (Version 4.0)
#
# $Id: cap.spec 1402 2010-05-21 23:24:41Z cashmont $
Name:         cap
Packager:     cap4-devel_AT_lists_DOT_sf_DOT_net
Version:      4.1
Release:      RELEASE
Epoch:        0
BuildArch:    noarch
License:      GPL
Summary:      Cluster Administration Package
Group:        Productivity/Clustering/Computing
URL:          http://www.capforge.org
Source0:      http://www.capforge.com/downloads/cap/%{name}-%{version}.tar.gz
#Requires:     perl-DBI >= 1.42
#Requires:     tcl tk expect perl perl-DBD-CSV perl-Config-Simple 
#Requires:     perl-Text-CSV_XS perl-DBD-CSV perl-SQL-Statement perl-DBD-AnyData perl-Text-Template
#Requires:     perl-Text-Template perl-Expect perl-IO-Stty

#Requires: perl-DBD-Excel perl-Spreadsheet-WriteExcel perl-Spreadsheet-ParseExcel 
#Requires: perl-Spreadsheet-BasicRead perl-Frontier perl-Jcode perl-Unicode-Map
#Requires: perl-Compress-Zlib perl-DBD-File


BuildRoot:    %{_tmppath}/%{name}-%{version}-%{release}-build
# if no cap_home passed in assume /opt/cap4
%{!?_cap_home: %define _cap_home /opt/cap4}
#-%define _capconf_home /etc
#-%define _capdb_home /var/lib/cap
#-%define _cap_workorder_home /var/spool/cap


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
to fit the needs of other installation methods available. clusters. 

Authors:
--------
    CAPforge.org

#%package test
#Summary:      The CAP Test Package
#Group:        Productivity/Clustering/Computing
#Requires:     cap
#PreReq:       /bin/chmod /bin/rm /bin/cp /bin/mv

#%description test
#This package includes the files necessary to create a test environment.

#Authors:
#--------
#    CAPforge.org

%pre

%prep
%setup -q -n %{name}-%{version} 

%build
./build.sh ${RPM_BUILD_ROOT}

%install
./install.sh ${RPM_BUILD_ROOT}

%post
./postinstall.sh ${RPM_BUILD_ROOT}

%postun 

%preun

#%preun test

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_cap_home}/etc/*
%{_cap_home}/src/*
%{_cap_home}/share/doc/*
%{_cap_home}/bin/*
%{_cap_home}/libexec/*
/usr/share/doc/cap4 
/usr/libexec/cap4 
/usr/src/cap4 
/usr/bin/deploy
/etc/profile.d/cap.sh
/etc/profile.d/cap.csh
#%config(noreplace) %{_capconf_home}/sysconfig/cap
#%config(noreplace) %{_capconf_home}/profile.d/cap.csh
#%config(noreplace) %{_capconf_home}/profile.d/cap.sh
#%config(noreplace) %{_capconf_home}/cap/conf/cap.conf
#%config(noreplace) %{_capconf_home}/cap/conf.d/client_proxy.conf
#%config(noreplace) %{_capconf_home}/cap/conf.d/client_cache.conf
#%config(noreplace) %{_capconf_home}/cap/conf.d/workorder.conf
#%docdir %{_capconf_home}/share/doc/cap4
#%{_capconf_home}/rc.d/init.d/*
#%{_cap_home}/sbin/*
#%{_cap_home}/bin/*
#%{_cap_home}/include/cap/*
#%{_cap_workorder_home}
#%{_cap_home}/share/man/man1/*
#%{_cap_home}/share/man/man3/*
#%{_capconf_home}/cap

#%files test
#%defattr(-,root,root)
#%{_capdb_home}

%changelog -n cap
