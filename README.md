SRPM tools for git 2.23.x

This github repo includes tools for building git-2.23.x RPM's. It is
based on the latest Fedora RPMs, with hooks for buiiding on Fedora and
RHEL, and with modifications from iusrelease to bundle as "git2u", for
separate installation from the standard "git" package and
repositories.

    https://www.kernel.org/pub/software/scm/git/

Download the tarballs, and run "make build" to build a local RPM under rpmbuild.

Run "make" to use "mock" to build the default designated RPM's in the
local working directories such as epel-7-x86_64 and epel-6-x86_64.

       	  Nico Kadel-Garcia <nkadelgmail.com>
