POFILES := $(wildcard po/*.po)
MOFILES := $(patsubst po/%.po,po/build/locale/%/LC_MESSAGES/waybar-updates.mo,$(POFILES))

.PHONY: mo

mo: $(MOFILES)

po/build/locale/%/LC_MESSAGES/waybar-updates.mo: po/%.po
	@mkdir -p po/build/locale/$*/LC_MESSAGES
	msgfmt -o $@ $<