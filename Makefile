.PHONY: install uninstall reinstall

install:
	./install.sh

uninstall:
	./uninstall.sh

reinstall:
	./uninstall.sh
	make install
