all: build/highlight.pack.js

update: addons/builtin.json addons/binary.json $(REPOS) addons/banned.html

REPOS = \
	addons/gotham/addons.xml \
	addons/helix/addons.xml \
	addons/isengard/addons.xml \
	addons/jarvis/addons.xml \
	addons/krypton/addons.xml \
	addons/leia/addons.xml \


addons/builtin.json: FORCE
	@echo curl -o $@ https://api.github.com/repos/xbmc/xbmc/contents/addons
	@mkdir -p `dirname $@`
	@cd `dirname $@`; curl -s -o .`basename $@` https://api.github.com/repos/xbmc/xbmc/contents/addons
	@cd `dirname $@`; diff -q `basename $@` .`basename $@` > /dev/null 2> /dev/null || mv .`basename $@` `basename $@`
	@cd `dirname $@`; rm -f .`basename $@`

addons/binary.json: FORCE
	@echo curl -o $@ https://api.github.com/repos/xbmc/repo-binary-addons/contents
	@mkdir -p `dirname $@`
	@cd `dirname $@`; curl -s -o .`basename $@` https://api.github.com/repos/xbmc/repo-binary-addons/contents
	@cd `dirname $@`; diff -q `basename $@` .`basename $@` > /dev/null 2> /dev/null || mv .`basename $@` `basename $@`
	@cd `dirname $@`; rm -f .`basename $@`

$(REPOS): FORCE
	@echo curl -L -o $@ https://mirrors.kodi.tv/$@
	@mkdir -p `dirname $@`
	@cd `dirname $@`; curl -s -L -o .`basename $@` -z .`basename $@` https://mirrors.kodi.tv/$@
	@cd `dirname $@`; diff -q `basename $@` .`basename $@` > /dev/null 2> /dev/null || cp .`basename $@` `basename $@`

addons/banned.html: FORCE
	@echo curl -o $@ 'https://kodi.wiki/index.php?title=Official:Forum_rules/Banned_add-ons&action=edit'
	@mkdir -p `dirname $@`
	@cd `dirname $@`; curl -s -o .`basename $@` 'https://kodi.wiki/index.php?title=Official:Forum_rules/Banned_add-ons&action=edit'
	@cd `dirname $@`; sed -i -E -e 's|,"wgRequestId":"[^"]+"||g' -e 's|"wgBackendResponseTime":[0-9]+||g' .`basename $@`
	@cd `dirname $@`; diff -q `basename $@` .`basename $@` > /dev/null 2> /dev/null || mv .`basename $@` `basename $@`
	@cd `dirname $@`; rm -f .`basename $@`

src/languages/kodi.js: generateKodiJs.py src/languages/kodi.js.in addons/builtin.json addons/binary.json $(REPOS) addons/banned.html
	./generateKodiJs.py

build/highlight.pack.js: src/languages/kodi.js
	node tools/build.js kodi

FORCE:
