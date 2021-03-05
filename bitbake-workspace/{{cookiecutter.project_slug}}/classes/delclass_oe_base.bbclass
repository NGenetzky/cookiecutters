# Attempts to make meta-bb compatible with 'oe-core/meta'.

# LICENSE is required for even basic parsing.
LICENSE ??= "CLOSED"
# LIC_FILES_CHKSUM is required for a sanity check
LIC_FILES_CHKSUM ??= ""

# This will add many dependencies
INHIBIT_DEFAULT_DEPS ??= '1'

# NOTE: Copied nopackages.bbclass here.
# inherit nopackages
deltask do_package
deltask do_package_write_rpm
deltask do_package_write_ipk
deltask do_package_write_deb
deltask do_package_qa
deltask do_packagedata
deltask do_package_setscene
deltask do_package_write_rpm_setscene
deltask do_package_write_ipk_setscene
deltask do_package_write_deb_setscene
deltask do_package_qa_setscene
deltask do_packagedata_setscene

deltask do_fetch
deltask do_unpack
deltask do_patch
deltask do_configure
deltask do_compile
deltask do_install

deltask do_populate_lic
deltask do_populate_lic_setscene
deltask do_populate_recipes_sysroot
deltask do_populate_sysroot
deltask do_populate_sysroot_setscene
deltask do_prepare_recipe_sysroot
