POFILES := $(wildcard po/*.po)
MOFILES := $(patsubst po/%.po,po/build/locale/%/LC_MESSAGES/waybar-updates.mo,$(POFILES))

$(MOFILES): po/build/locale/%/LC_MESSAGES/waybar-updates.mo : po/%.po
	mkdir -p $(dir $@)
	msgfmt -o $@ $<

all: $(MOFILES)

PREFIX?=/usr/local
BINDIR?=$(PREFIX)/bin
SHAREDIR?=$(PREFIX)/share
LOCALEDIR?=$(SHAREDIR)/locale
DESTDIR?=

install:
	mkdir -p $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(LOCALEDIR)
	install -m 755 waybar-updates $(DESTDIR)$(BINDIR)/waybar-updates
	@for mo in $(MOFILES) ; do \
    	lang="$$(echo "$$mo" | cut -d/ -f4)" ; \
    	install -Dm 644 "$$mo" "$(DESTDIR)$(LOCALEDIR)/$$lang/LC_MESSAGES/waybar-updates.mo" || exit $$? ; \
    done

clean:
	rm -rf po/build

.PHONY: all install clean