#
# Build mock and local RPM versions of tools for RT
#

# Assure that sorting is case sensitive
LANG=C

# Ignore ownership and group,
RSYNCOPTS=-a --no-owner --no-group
# Skip existing files to avoid binary churn in yum repos
RSYNCSAFEOPTS=$(RSYNCOPTS) --ignore-existing 

# "mock" configurations to build with, activate only as needed
# fedora-28 is not availalbe on RHEL 6 version of mock
#MOCKS+=fedora-29-i386
#MOCKS+=epel-7-i386
#MOCKS+=epel-6-i386

#MOCKS+=fedora-29-x86_64
MOCKS+=epel-7-x86_64
MOCKS+=epel-6-x86_64

SPEC = `ls *.spec`

all:: $(MOCKS)

srpm:: FORCE
	@echo Building $(SPEC) SRPM
	rm -rf rpmbuild
	rpmbuild \
		--define '_topdir $(PWD)/rpmbuild' \
		--define '_sourcedir $(PWD)' \
		-bs $(SPEC) --nodeps

build:: srpm FORCE
	rpmbuild \
		--define "_topdir $(PWD)/rpmbuild" \
		--rebuild rpmbuild/SRPMS/*.src.rpm

$(MOCKS):: FORCE
	@if [ -n "`find $@ -name \*.rpm ! -name \*.src.rpm 2>/dev/null`" ]; then \
		echo "	Skipping $(SPEC) in $@ with RPMS"; \
	else \
		rm -rf $@; \
		$(MAKE) srpm; \
		echo "Storing " rpmbuild/SRPMS/*.src.rpm "as $@.src.rpm"; \
		/bin/mv rpmbuild/SRPMS/*.src.rpm $@.src.rpm; \
		echo "Building $@.src.rpm in $@"; \
		rm -rf $@; \
		/usr/bin/mock -q -r $@ \
		     --resultdir=$(PWD)/$@ \
		     $@.src.rpm; \
	fi

mock:: $(MOCKS)

install:: $(MOCKS)
	@echo $@ not enabled

clean::
	rm -rf $(MOCKS)
	rm -rf rpmbuild
	rm -rf */

realclean distclean:: clean
	rm -f *.src.rpm

FORCE:
