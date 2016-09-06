
COMPILER = gcc
DIR_PERM=0755
FILE_PERM=0644

LIBPURPLE_CFLAGS += $(shell pkg-config --cflags glib-2.0 json-glib-1.0 purple)
LIBPURPLE_LIBS += $(shell pkg-config --libs glib-2.0 json-glib-1.0 purple)
PLUGIN_DIR_PURPLE=$(shell pkg-config --variable=plugindir purple)
DATA_ROOT_DIR_PURPLE=$(shell pkg-config --variable=datarootdir purple)

PRPL_NAME=libpushbullet.so
PRPL_LIBNAME=${PRPL_NAME}

PUSHBULLET_SOURCES = \
	libpushbullet.c 

PKG_VERSION=0.1
PKG_RELEASE=1
PKG_NAME=pidgin-pushbullet_$(PKG_VERSION)-$(PKG_RELEASE)_amd64.deb

.PHONY:	all clean install package
all: ${PRPL_NAME}
install:
	mkdir -m $(DIR_PERM) -p $(DESTDIR)$(PLUGIN_DIR_PURPLE)
	install -m $(FILE_PERM) $(PRPL_LIBNAME) $(DESTDIR)$(PLUGIN_DIR_PURPLE)/$(PRPL_NAME)
	mkdir -m $(DIR_PERM) -p $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/16
	install -m $(FILE_PERM) icons/pushbullet16.png $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/16/pushbullet.png
	mkdir -m $(DIR_PERM) -p $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/22
	install -m $(FILE_PERM) icons/pushbullet22.png $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/22/pushbullet.png
	mkdir -m $(DIR_PERM) -p $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/48
	install -m $(FILE_PERM) icons/pushbullet48.png $(DESTDIR)$(DATA_ROOT_DIR_PURPLE)/pixmaps/pidgin/protocols/48/pushbullet.png
clean:
	rm -f libpushbullet.so

${PRPL_NAME}: ${PUSHBULLET_SOURCES}
	${COMPILER} -Wall -I. -g -O2 -fPIC -pipe ${PUSHBULLET_SOURCES} -o $@ ${LIBPURPLE_CFLAGS} ${LIBPURPLE_LIBS} -shared

package: ${PKG_NAME}
${PKG_NAME}: ${PRPL_NAME}
	sudo checkinstall -D --pkgname="pidgin-pushbullet" --pkgversion=${PKG_VERSION} --pkgrelease=${PKG_RELEASE} --pkgsource=https://github.com/EionRobb/pidgin-pushbullet --maintainer=tubaman@fattuba.com --provides=pidgin-pushbullet --requires=libpurple0
