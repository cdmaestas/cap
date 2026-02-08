include ./make.def

TOOLDIRS = conman freeipmi genders nodediag pdsh powerman diskscrub \
	python-hostlist collectl collectl-utils

OTHERS = munge nfsroot slurm-spank-plugins io-watchdog padb sqlog diskscrub slurm torque

download downloadstatus clean distclean:
	$(call print-header,"cap4 src $@")
	@for TOOLS in $(TOOLDIRS) $(OTHERS); do \
		[ -d $$TOOLS ] && $(MAKE) -C $$TOOLS $@; \
	done;

rpm rpmstatus:
	$(call print-header,"cap4 src $@")
	@for TOOLS in $(TOOLDIRS); do \
		[ -d $$TOOLS ] && $(MAKE) -C $$TOOLS $@; \
	done;


