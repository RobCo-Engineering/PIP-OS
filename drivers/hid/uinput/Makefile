# Variables
PACKAGE_NAME = pipboy-hid
VERSION = 1.0
ARCH = arm64
BINARY = pipboy-control
SOURCE = pipboy-control.c
SERVICE_FILE = pipboy-hid.service

# Directories
BIN_DIR = $(PACKAGE_NAME)/usr/local/bin
SERVICE_DIR = $(PACKAGE_NAME)/lib/systemd/system
DEBIAN_DIR = $(PACKAGE_NAME)/DEBIAN

# Targets
all: build

build: $(BINARY) package

$(BINARY): $(SOURCE)
	gcc -g $(SOURCE) -O3 -o $(BINARY)

package: $(BINARY)
	mkdir -p $(BIN_DIR)
	mkdir -p $(SERVICE_DIR)
	mkdir -p $(DEBIAN_DIR)
	mv $(BINARY) $(BIN_DIR)/
	cp $(SERVICE_FILE) $(SERVICE_DIR)/
	echo "Package: $(PACKAGE_NAME)" > $(DEBIAN_DIR)/control
	echo "Version: $(VERSION)" >> $(DEBIAN_DIR)/control
	echo "Section: base" >> $(DEBIAN_DIR)/control
	echo "Priority: optional" >> $(DEBIAN_DIR)/control
	echo "Architecture: $(ARCH)" >> $(DEBIAN_DIR)/control
	echo "Depends: " >> $(DEBIAN_DIR)/control
	echo "Maintainer: Darrian <darrian@robco-industries.org>" >> $(DEBIAN_DIR)/control
	echo "Description: A brief description of your package" >> $(DEBIAN_DIR)/control
	dpkg-deb --build $(PACKAGE_NAME)

clean:
	rm -rf $(PACKAGE_NAME)
	rm -f $(BINARY)

.PHONY: all build package clean
