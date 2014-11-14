.PHONY: bb ccgx clean distclean fetch fetch-all install repos.conf sdk

build/conf/bblayers.conf:
	@echo 'LCONF_VERSION = "6"' > build/conf/bblayers.conf
	@echo 'BBPATH = "$${TOPDIR}"' >> build/conf/bblayers.conf
	@echo 'BBFILES ?= ""' >> build/conf/bblayers.conf
	@echo >> build/conf/bblayers.conf
	@echo 'BBLAYERS = " \' >> build/conf/bblayers.conf
	@find . -wholename "*/conf/layer.conf" | sed -e 's,/conf/layer.conf,,g' -e 's,^./,,g' | sort > metas.found
	@comm -1 -2 metas.found metas.whitelist | sed -e 's,$$, \\,g' -e "s,^,$$PWD/,g" >> build/conf/bblayers.conf
	@echo '"' >> build/conf/bblayers.conf

bb: build/conf/bblayers.conf
	@bash --init-file sources/openembedded-core/oe-init-build-env

clean:
	@rm -rf build/tmp-eglibc
	@rm -rf build/sstate-cache
	@rm -rf deploy
	@rm -f build/conf/bblayers.conf

ccgx: build/conf/bblayers.conf
	. ./sources/openembedded-core/oe-init-build-env build && bitbake bpp3-rootfs

distclean: clean
	@rm -rf downloads

fetch-all:
	@rm -f build/conf/bblayers.conf
	@while read p; do ./git-fetch-remote.sh $$p; done <repos.conf

install:
	@cd install && make prod && make recover

repos.conf:
	@conf=$$PWD/repos.conf; rm $$conf; ./repos_cmd "git-show-remote.sh \$$repo >> $$conf"

sdk:
	. ./sources/openembedded-core/oe-init-build-env build && bitbake meta-toolchain-qte
