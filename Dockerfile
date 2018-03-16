FROM debian:jessie

MAINTAINER Nicolas Mendoza <mendoza@pvv.ntnu.no>

RUN apt-get update && apt-get install -y perl-modules libmodule-install-perl make build-essential libtap-harness-archive-perl fakeroot debhelper dh-make-perl apt-file libparse-cpan-meta-perl libcpan-meta-yaml-perl libscalar-list-utils-perl

RUN echo "builder-jessie" > /etc/mailname

RUN mkdir /var/cache/apt/archives/build && cd /var/cache/apt/archives/build
RUN export PERL_MM_OPT="INSTALL_BASE=/usr/local" && export BUILDING_AS_PACKAGE=1 \
 && dh-make-perl --core-ok --packagename cpan-libextutils-makemaker-perl --cpan ExtUtils::MakeMaker \
 && (cd cpan-libextutils-makemaker-perl && cp -nrf bundled/*-*/* /usr/share/perl5 && (echo override_dh_usrlocal: >> debian/rules) && debian/rules binary ) \
 && dpkg -i cpan-libextutils-makemaker-perl*.deb
