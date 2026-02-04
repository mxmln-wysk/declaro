SUDO ?= sudo

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
SHRDIR = $(PREFIX)/share
SHRBINDIR = $(SHRDIR)/declarch/bin
SHRCONFDIR = $(SHRDIR)/declarch/config
ETC_DECLARCH_DIR = /home/mwysk/.config/declarch


.PHONY: all install uninstall test

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing declarch..."
	$(SUDO) install -Dm755 src/declarch.sh $(DESTDIR)$(BINDIR)/declarch
	$(SUDO) install -Dm644 src/commands/clean.sh $(DESTDIR)$(SHRBINDIR)/clean.sh
	$(SUDO) install -Dm644 src/commands/diff.sh $(DESTDIR)$(SHRBINDIR)/diff.sh
	$(SUDO) install -Dm644 src/commands/edit.sh $(DESTDIR)$(SHRBINDIR)/edit.sh
	$(SUDO) install -Dm644 src/commands/generate.sh $(DESTDIR)$(SHRBINDIR)/generate.sh
	$(SUDO) install -Dm644 src/commands/list.sh $(DESTDIR)$(SHRBINDIR)/list.sh
	$(SUDO) install -Dm644 src/commands/declare.sh $(DESTDIR)$(SHRBINDIR)/declare.sh
	$(SUDO) install -Dm644 src/commands/status.sh $(DESTDIR)$(SHRBINDIR)/status.sh
	$(SUDO) install -Dm644 src/commands/export.sh $(DESTDIR)$(SHRBINDIR)/export.sh
	$(SUDO) install -Dm644 src/commands/import.sh $(DESTDIR)$(SHRBINDIR)/import.sh
	$(SUDO) install -Dm644 src/commands/install-config.sh $(DESTDIR)$(SHRBINDIR)/install-config.sh
	$(SUDO) install -Dm644 src/utils.sh $(DESTDIR)$(SHRBINDIR)/utils.sh
	$(SUDO) install -d $(DESTDIR)$(SHRCONFDIR)
	$(SUDO) cp config/* $(DESTDIR)$(SHRCONFDIR)
	@echo "Done."

install-config:
	@echo "Installing configuration..."
	SUDO="$(SUDO) " SHRBINDIR="src" ETC_DECLARCH_DIR=$(DESTDIR)$(ETC_DECLARCH_DIR) IS_CALLED_AS_SUBCOMMAND="false" bash src/commands/install-config.sh
	@echo "Done."


uninstall:
	@echo "Uninstalling declarch..."
	$(SUDO) rm -f $(DESTDIR)$(BINDIR)/declarch
	$(SUDO) rm -rf $(DESTDIR)$(SHRDIR)/declarch
	@echo "Done."

test:
	@echo "Testing declarch..."
	@./test/bats/bin/bats test/test_cases/
	@echo "Done."
