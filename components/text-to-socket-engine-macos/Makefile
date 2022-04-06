# This Makefile is loosely based on the following guide:
#
# OS X: Creating Packages from the Command Line - Tutorial and a Makefile - Part II
# http://thegreyblog.blogspot.com/2014/06/os-x-creating-packages-from-command.html

PROGRAM = AutomationVoice
VOLUME_NAME = Bocoup Automation Voice
IDENTIFIER = com.bocoup.automation-voice
DISTDIR = ./dist
DEPSDIR = ./deps
BINARIES = /tmp/AutomationVoice.dst
DMGFILE = $(DISTDIR)/$(PROGRAM).dmg
PRODUCT = $(DISTDIR)/$(PROGRAM).pkg
COMPONENT = $(DEPSDIR)/$(PROGRAM)Component.pkg
COMPONENT_PFILE = $(PROGRAM).plist
DISTRIBUTION_FILE = distribution.plist
REQUIREMENTS = requirements.plist

.PHONY: all
all: $(DISTDIR) $(DEPSDIR) $(PRODUCT) $(DMGFILE)

$(DISTDIR):
	mkdir $(DISTDIR)

$(DEPSDIR):
	mkdir $(DEPSDIR)

$(PRODUCT): $(BINARIES) $(REQUIREMENTS) $(COMPONENT_PFILE) $(COMPONENT) $(DISTRIBUTION_FILE)
	productbuild \
		--distribution $(DISTRIBUTION_FILE) \
		--resources . \
		--package-path $(DEPSDIR) \
		--package-path $(COMPONENT) \
		$(PRODUCT)

$(BINARIES):
	mkdir -p $(BINARIES)
	xcodebuild install \
		DSTROOT=$(BINARIES) \
		MACOSX_DEPLOYMENT_TARGET=10.15 \
		SDKROOT=macosx10.15

$(COMPONENT_PFILE):
	pkgbuild \
		--min-os-version 10.15 \
		--analyze \
		--root $(BINARIES) \
		$(COMPONENT_PFILE)

$(COMPONENT): $(DEPSDIR) $(BINARIES) $(COMPONENT_PFILE)
	pkgbuild \
		--min-os-version 10.15 \
		--identifier $(IDENTIFIER) \
		--root $(BINARIES) \
		--component-plist $(COMPONENT_PFILE) \
		$(COMPONENT)

$(DISTRIBUTION_FILE): $(COMPONENT)
	productbuild \
		--synthesize \
		--product $(REQUIREMENTS) \
		--package $(COMPONENT) \
		$(DISTRIBUTION_FILE)

$(DMGFILE):
	hdiutil create \
		-volname "$(VOLUME_NAME)" \
		-srcfolder ./dist \
		-ov \
		$(DMGFILE)

.PHONY: clean
clean: distclean compclean
	-rm -f $(DMGFILE) $(PRODUCT) $(COMPONENT)
	-rm -rf $(BINARIES)

.PHONY: distclean
distclean:
	-rm -f $(DISTRIBUTION_FILE)

.PHONY: compclean
compclean:
	-rm -f $(COMPONENT_PFILE)
