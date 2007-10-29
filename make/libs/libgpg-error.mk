PACKAGE_LC:=libgpg-error
PACKAGE_UC:=LIBGPG_ERROR
$(PACKAGE_UC)_VERSION:=1.1
$(PACKAGE_INIT_LIB)
$(PACKAGE_UC)_LIB_VERSION:=0.1.4
$(PACKAGE_UC)_SOURCE:=libgpg-error-$($(PACKAGE_UC)_VERSION).tar.gz
$(PACKAGE_UC)_SITE:=http://ftp.gnupg.org/gcrypt/libgpg-error
$(PACKAGE_UC)_BINARY:=$($(PACKAGE_UC)_DIR)/src/.libs/libgpg-error.so.$($(PACKAGE_UC)_LIB_VERSION)
$(PACKAGE_UC)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libgpg-error.so.$($(PACKAGE_UC)_LIB_VERSION)
$(PACKAGE_UC)_TARGET_BINARY:=$($(PACKAGE_UC)_TARGET_DIR)/libgpg-error.so.$($(PACKAGE_UC)_LIB_VERSION)

$(PACKAGE_UC)_CONFIGURE_OPTIONS += --enable-shared
$(PACKAGE_UC)_CONFIGURE_OPTIONS += --enable-static


$(PACKAGE_SOURCE_DOWNLOAD)
$(PACKAGE_UNPACKED)
$(PACKAGE_CONFIGURED_CONFIGURE)

$($(PACKAGE_UC)_BINARY): $($(PACKAGE_UC)_DIR)/.configured
	PATH=$(TARGET_TOOLCHAIN_PATH) \
		$(MAKE) -C $(LIBGPG_ERROR_DIR)

$($(PACKAGE_UC)_STAGING_BINARY): $($(PACKAGE_UC)_BINARY)
	PATH=$(TARGET_TOOLCHAIN_PATH) \
		$(MAKE) -C $(LIBGPG_ERROR_DIR) \
		prefix=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr \
		exec_prefix=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr \
		bindir=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin \
		datadir=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/share \
		install
	$(SED) -i -e "s,^libdir=.*,libdir=\'$(TARGET_TOOLCHAIN_STAGING_DIR)/lib\',g" \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/libgpg-error.la

$($(PACKAGE_UC)_TARGET_BINARY): $($(PACKAGE_UC)_STAGING_BINARY)
	cp -a $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libgpg-error*.so* $(LIBGPG_ERROR_TARGET_DIR)/
	$(TARGET_STRIP) $@

libgpg-error: $($(PACKAGE_UC)_STAGING_BINARY)

libgpg-error-precompiled: uclibc libgpg-error $($(PACKAGE_UC)_TARGET_BINARY)

libgpg-error-clean:
	-$(MAKE) -C $(LIBGPG_ERROR_DIR) clean
	rm -f $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libgpg-error*

libgpg-error-uninstall:
	rm -f $(LIBGPG_ERROR_TARGET_DIR)/libgpg-error*.so*

$(PACKAGE_FINI)
