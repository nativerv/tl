# tl - simple google translate cli
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

all: install

tl:

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp tl ${DESTDIR}${PREFIX}/bin/tl

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/tl

.PHONY: all install uninstall
