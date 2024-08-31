# tl - simple google translate cli
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

all: install

tl:

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install -m 755 tl -t ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/tl

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/tl

.PHONY: all install uninstall
