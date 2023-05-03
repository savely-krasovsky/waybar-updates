POFILES := $(wildcard po/*.po)
MOFILES := $(patsubst po/%.po,po/build/locale/%/LC_MESSAGES/checkupdates.sh.mo,$(POFILES))

all:: $(MOFILES)

po/build/locale/%/LC_MESSAGES/checkupdates.sh.mo: po/%.po
	@mkdir -p po/build/locale/$*/LC_MESSAGES
	msgfmt -o $@ $<