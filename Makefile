# @brief Helper makefile to set up the jail root file system properly
# It uses busybox as the shell and bunch of other utilities and the 'mklibs'
# to strip the sysroot of all the unnecessary components.
# @author T.Ostaszewski

.DEFAULT_GOAL   :=all

# Set the lightweight shell
SHELL           :=/bin/sh

# Enable secondary expansion
# This one is needed for the autodir.mk to work properly.
.SECONDEXPANSION:

include autodir.mk
include eyecandy.mk 

# Verbosity flag
V                           :=0

ifeq ($(V),0)
NOECHO                      :=@
else
NOECHO                      :=
endif

NATIVE_CROSS_COMPILE        :=
# A compiler whose sysroot is to be tested on the target
JAIL_TOOLCHAINS_HOME        :=$(HOME)/x-tools/
CROSS_COMPILE               :=arm-cortexA8-linux-gnueabi-
ARCH                        :=$(firstword $(subst -, ,$(CROSS_COMPILE)))
ifeq ($(CROSS_COMPILE),)
# Set the default output directory
BUILD_ROOT      ?=build-native/
else
CROSS_COMPILE_PREFIX        :=$(CROSS_COMPILE:%-=%)
BUILD_ROOT      ?=build-$(CROSS_COMPILE_PREFIX)/
endif
JAIL_TOOLCHAIN_ROOT         :=$(JAIL_TOOLCHAINS_HOME)$(CROSS_COMPILE_PREFIX)/
JAIL_TOOLCHAIN_PATH         :=$(JAIL_TOOLCHAIN_ROOT)bin
JAIL_SYSROOT                =$(shell env PATH=$(PATH):$(JAIL_TOOLCHAIN_PATH) $(CROSS_COMPILE)gcc -print-sysroot)
NATIVE_CFLAGS               :=-O3 -Wall -Werror
# A compiler whose sysroot is currently being used on the target
# By default, we set it to the same as the new compiler. Due to binary
# ABI compatibility, this may work most of the time.
ROOT_CROSS_COMPILE          :=$(CROSS_COMPILE)
ROOT_CFLAGS                 :=

JAIL_SYSROOT_CONTENTS       =$(shell find $(JAIL_SYSROOT) -depth \( -type f -o -type l \) -print)
JAIL_SYSROOT_BARE           =$(patsubst $(JAIL_SYSROOT)%,%,$(JAIL_SYSROOT_CONTENTS))
JAIL_SYSROOT_TARGET         =$(addprefix $(BUILD_ROOT)tmpfs/,$(JAIL_SYSROOT_BARE))

# Kernel part
KERNEL_DIR                  =/home/tomek/beaglebone-dev/kernel/kernel/

# The directory to install mklibs package into
MKLIBS_INSTALL_DIR      :=$(BUILD_ROOT)pkg/

# Mklibs part
MKLIBS_VERSION          :=mklibs-0.1.34
MKLIBS_ARCH             :=$(MKLIBS_VERSION).tar.gz
MKLIBS_TAR              :=$(MKLIBS_VERSION).tar
PKG_SRC_DIR             :=$(BUILD_ROOT)src/
MKLIBS_BIN_PATH         :=$(MKLIBS_INSTALL_DIR)bin/
MKLIBS_FILE_LIST        :=$(shell tar -tf $(MKLIBS_ARCH))
MKLIBS_BUILD_FILE_LIST  :=$(addprefix $(PKG_SRC_DIR),$(MKLIBS_FILE_LIST))
MKLIBS_INSTALLED_FILES  := \
 $(MKLIBS_INSTALL_DIR)share/man/man1/mklibs-readelf.1 \
 $(MKLIBS_INSTALL_DIR)share/man/man1/mklibs.1 \
 $(MKLIBS_INSTALL_DIR)share/man/man1/mklibs-copy.1 \
 $(MKLIBS_INSTALL_DIR)bin/mklibs-copy \
 $(MKLIBS_INSTALL_DIR)bin/mklibs \
 $(MKLIBS_INSTALL_DIR)bin/mklibs-readelf \
 $(MKLIBS_INSTALL_DIR)lib/mklibs/python/mklibs/utils/logging.py \
 $(MKLIBS_INSTALL_DIR)lib/mklibs/python/mklibs/utils/main.py \
 $(MKLIBS_INSTALL_DIR)lib/mklibs/python/mklibs/utils/__init__.py \
 $(MKLIBS_INSTALL_DIR)lib/mklibs/python/mklibs/__init__.py

# Set the path for the tools
PATH            :=$(PATH):$(abspath $(MKLIBS_INSTALL_DIR)bin/):$(abspath $(JAIL_TOOLCHAIN_PATH))
export PATH ARCH
COMPILER_TRIPLET    :=$(CROSS_COMPILE:%-=%)

DROPBEAR_BINARIES        =$(shell find dropbear-0.51-binary/$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
DROPBEAR_BARE            =$(patsubst dropbear-0.51-binary/$(COMPILER_TRIPLET)/%,%,$(DROPBEAR_BINARIES))

ZLIB_BINARIES            =$(shell find zlib-1.2.8-binary/$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
ZLIB_BARE                =$(patsubst zlib-1.2.8-binary/$(COMPILER_TRIPLET)/%,%,$(ZLIB_BINARIES))

OPENSSL_BINARIES            =$(shell find openssl-0.9.8x-binary/$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
OPENSSL_BARE                =$(patsubst openssl-0.9.8x-binary/$(COMPILER_TRIPLET)/%,%,$(OPENSSL_BINARIES))

OPENSSH_BINARIES            =$(shell find openssh-6.2p2-binary/$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
OPENSSH_BARE                =$(patsubst openssh-6.2p2-binary/$(COMPILER_TRIPLET)/%,%,$(OPENSSH_BINARIES))

SKELETON_ROOTFS_BARE     =$(patsubst skeleton-sysroot/%,%,$(shell find skeleton-sysroot/ -depth \( -type f -o -type l \)))

BUSYBOX_BINARIES         =$(shell find busybox-1.20.2-binary/$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
BUSYBOX_BARE             =$(patsubst busybox-1.20.2-binary/$(COMPILER_TRIPLET)/%,%,$(BUSYBOX_BINARIES))

STRACE_BINARIES_DIR      :=strace-4.6-binary/
STRACE_BINARIES          =$(shell find $(STRACE_BINARIES_DIR)$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
STRACE_BARE              =$(patsubst $(STRACE_BINARIES_DIR)$(COMPILER_TRIPLET)/%,%,$(STRACE_BINARIES))

E2FSPROGS_BINARIES_DIR     :=e2fsprogs-1.42.8-binary/
E2FSPROGS_BINARIES         =$(shell find $(E2FSPROGS_BINARIES_DIR)$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
E2FSPROGS_BARE             =$(patsubst $(E2FSPROGS_BINARIES_DIR)$(COMPILER_TRIPLET)/%,%,$(E2FSPROGS_BINARIES))

E2FSPROGS_BINARIES_DIR     :=e2fsprogs-1.42.8-binary/
E2FSPROGS_BINARIES         =$(shell find $(E2FSPROGS_BINARIES_DIR)$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \))
E2FSPROGS_BARE             =$(patsubst $(E2FSPROGS_BINARIES_DIR)$(COMPILER_TRIPLET)/%,%,$(E2FSPROGS_BINARIES))

LZO206_BINARIES_DIR     :=lzo-2.06-binary/
LZO206_BINARIES         =$(shell find $(LZO206_BINARIES_DIR)$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \)) 
LZO206_BARE             =$(patsubst $(LZO206_BINARIES_DIR)$(COMPILER_TRIPLET)/%,%,$(LZO206_BINARIES)) 

MTD150_BINARIES_DIR     :=mtd-utils-1.5.0-binary/
MTD150_BINARIES         =$(shell find $(MTD150_BINARIES_DIR)$(COMPILER_TRIPLET)/ -depth \( -type f -o -type l \)) 
MTD150_BARE             =$(patsubst $(MTD150_BINARIES_DIR)$(COMPILER_TRIPLET)/%,%,$(MTD150_BINARIES)) 

# #NotesOnRootfsAndSysroot
# Okay, the plan is this:
# 1/ Create a skeleton sysroot on the scaffold that is there in the compiler's sysroot directory. We 
# populate the sysroot with _ALL_ the binary packages that we have for the target.
# 2/ Populate the rootfs (the one created on the target) with only selected binary packages

# Implementing 1/ from #NotesOnRootfsAndSysroot

# Create a set of rules that populate compiler's sysroot with binary packages.
#  Populate sysroot with Dropbear binaries & libraries
$(JAIL_SYSROOT)/%: dropbear-0.51-binary/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))
#  Populate sysroot with Zlib binaries & libraries
$(JAIL_SYSROOT)/%: zlib-1.2.8-binary/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))
#  Populate sysroot with OpenSsl binaries & libraries
$(JAIL_SYSROOT)/%: openssl-0.9.8x-binary/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))
#  Populate sysroot with OpenSsl binaries & libraries
$(JAIL_SYSROOT)/%: openssh-6.2p2-binary/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))
#  Populate sysroot with Lzo binaries & libraries
$(JAIL_SYSROOT)/%: $(LZO206_BINARIES_DIR)/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))
#  Populate sysroot with Lzo binaries & libraries
$(JAIL_SYSROOT)/%: $(MTD150_BINARIES_DIR)/$(COMPILER_TRIPLET)/% 
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(JAIL_SYSROOT))

# Implementing 2/ from #NotesOnRootfsAndSysroot

# Pattern rule to populate rootfs with contents of the skeleton system
$(BUILD_ROOT)jail/% : skeleton-sysroot/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd skeleton-sysroot/ &&  find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)
# Pattern rule to populate rootfs with dropbear-0.51-binary
$(BUILD_ROOT)jail/% : dropbear-0.51-binary/$(COMPILER_TRIPLET)/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)
# Pattern rule to populate rootfs with busybox-1.20.2-binary
$(BUILD_ROOT)jail/% : busybox-1.20.2-binary/$(COMPILER_TRIPLET)/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)
# Pattern rule to populate rootfs with strace
$(BUILD_ROOT)jail/% : $(STRACE_BINARIES_DIR)$(COMPILER_TRIPLET)/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)
# Pattern rule to populate rootfs with e2fsprogs-1.42.8
$(BUILD_ROOT)jail/% : $(E2FSPROGS_BINARIES_DIR)$(COMPILER_TRIPLET)/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)
# Pattern rule to populate rootfs with mtd-utils-1.5.0
$(BUILD_ROOT)jail/% : $(MTD150_BINARIES_DIR)$(COMPILER_TRIPLET)/% | $$(@D)/.
	@$(ECHO_INSTALL) $(@)
	$(NOECHO)cd $(firstword $(subst /, ,$(<D)))/$(COMPILER_TRIPLET) && find . -depth -name $(*F) | cpio -pd --quiet $(abspath $(BUILD_ROOT)jail/)

# Pattern rule to populate busybox with busybox-1.20.2-binary

.PHONY: tmp-sysroot
tmp-sysroot: \
 $(addprefix $(JAIL_SYSROOT)/,\
    $(DROPBEAR_BARE) \
    $(ZLIB_BARE) \
    $(OPENSSL_BARE) \
    $(OPENSSH_BARE) \
    $(E2FSPROGS_BARE) \
    $(LZO206_BARE) \
    $(MTD150_BARE) \
)

.PHONY: rootfs
ROOTFS_PREQS    =  $(addprefix $(BUILD_ROOT)jail/,\
 $(BUSYBOX_BARE) \
 $(DROPBEAR_BARE) \
 $(STRACE_BARE) \
 $(E2FSPROGS_BARE) \
 $(MTD150_BARE) \
 $(SKELETON_ROOTFS_BARE) \
)

rootfs: $(ROOTFS_PREQS)

.PHONY: mklibs-file-list
mklibs-file-list:
	@echo $(sort $(MKLIBS_FILE_LIST))
	@echo $(firstword $(sort $(MKLIBS_FILE_LIST)))

$(MKLIBS_INSTALL_DIR).done: $(MKLIBS_BUILD_FILE_LIST) | $(MKLIBS_INSTALL_DIR)/.
	@$(ECHO_CONFIGURE) $(MKLIBS_VERSION)
	$(NOECHO)cd $(PKG_SRC_DIR)$(MKLIBS_VERSION); ./configure --prefix=$(abspath $(MKLIBS_INSTALL_DIR)) -q; $(MAKE) -s install
	@$(ECHO_MAKE) $(MKLIBS_VERSION)
	$(NOECHO)$(MAKE) -C $(PKG_SRC_DIR)$(MKLIBS_VERSION) -s install
	$(NOECHO)touch $(@)

.PHONY: src
src : $(MKLIBS_BUILD_FILE_LIST)

$(BUILD_ROOT)$(MKLIBS_TAR): $(MKLIBS_ARCH) | $(PKG_SRC_DIR)/.
	@$(ECHO_GZIP) $(@)
	$(NOECHO)gzip -dc $(<) > $(@)

$(MKLIBS_BUILD_FILE_LIST): $(BUILD_ROOT)$(MKLIBS_TAR) | $(PKG_SRC_DIR)/.
	@$(ECHO_UNTAR) $(@)
	$(NOECHO)tar -m -C $(PKG_SRC_DIR) -xf $(<) $(patsubst $(PKG_SRC_DIR)%,%,$(@))

.PHONY: mklibs
mklibs: $(MKLIBS_INSTALL_DIR).done
    
# 
.PHONY: all
all: $(BUILD_ROOT)jail.cpio

# Helper binary utilities
#   The 'chrootshell' utility that does transition into jail.
.PHONY: chrootshell

chrootshell: $(BUILD_ROOT)chrootshell

$(BUILD_ROOT)chrootshell: chrootshell.c | $$(@D)/.
	@$(ECHO_CC) $(@)
	$(NOECHO)$(ROOT_CROSS_COMPILE)gcc $(CPPFLAGS) $(ROOT_CFLAGS) -o $(@) $(^)
	$(NOECHO)$(ROOT_CROSS_COMPILE)strip $(@)

#   The 'make_jail_etc' utilty for passwd, group and shadow file generation
.PHONY: make_jail_etc

make_jail_etc: $(BUILD_ROOT)make_jail_etc

make_jail_etc_LD_FLAGS  := -lcrypt

$(BUILD_ROOT)make_jail_etc: make_jail_etc.c | $$(@D)/.
	@$(ECHO_CC) $(@)
	$(NOECHO)$(NATIVE_CROSS_COMPILE)gcc $(NATIVE_CFLAGS) $(CPPFLAGS) $(make_jail_etc_LD_FLAGS) -o $(@) $(^)

# The jail file system variables

#   Set the lightweight shell
JAIL_DEFAULT_SHELL  :=/bin/sh
JAIL_USER_NAME      :=peon
JAIL_USER_PASSWD    :=peon
JAIL_USER_HOME      :=/home/peon
JAIL_USER_ID        :=1002
JAIL_ROOT_DIR       :=$(BUILD_ROOT)jail/
JAIL_USER_SHELL     :=/bin/sh
JAIL_ROOT_FS_DIRS   :=$(addprefix $(JAIL_ROOT_DIR),\
 $(sort \
 bin \
 dev \
 etc \
 home \
 home/$(JAIL_USER_NAME) \
 lib \
 lib/modules \
 lib/firmware \
 mnt \
 proc \
 root \
 sbin \
 sys \
 tmp \
 usr/bin \
 usr/sbin \
 usr/lib \
 var/run \
 var/log \
))

.PHONY: jailfs
jailfs: $(BULID_ROOT)jail.cpio

.PHONY: jail-users

jail-users: \
 $(JAIL_ROOT_DIR)etc/passwd \
 $(JAIL_ROOT_DIR)etc/shadow \
 $(JAIL_ROOT_DIR)etc/group

$(JAIL_ROOT_DIR)etc/passwd: $(BUILD_ROOT)make_jail_etc | $$(@D)/.
	@$(ECHO_GENERATE) $(@)
	$(NOECHO) A=`mktemp /tmp/passwd.XXXXXX` && $(<) -P -h /root -u root -i 0 -s /bin/sh > $$A && $(<) -P -h $(JAIL_USER_HOME) -u $(JAIL_USER_NAME) -i $(JAIL_USER_ID) -s $(JAIL_USER_SHELL) >> $$A && mv $$A $(@)

$(JAIL_ROOT_DIR)etc/shadow: $(BUILD_ROOT)make_jail_etc | $$(@D)/.
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)$(RM) $(@)
	$(NOECHO)$(<) -S -u root -p "" > $(@)
	$(NOECHO)$(<) -S -u $(JAIL_USER_NAME) -p $(JAIL_USER_PASSWD) >> $(@)

$(JAIL_ROOT_DIR)etc/group: $(BUILD_ROOT)make_jail_etc | $$(@D)/.
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)$(RM) $(@)
	$(NOECHO)$(<) -G -u root > $(@)
	$(NOECHO)$(<) -G -u $(JAIL_USER_NAME) -i $(JAIL_USER_ID) >> $(@)

$(JAIL_ROOT_FS_DIRS): | $$(@D)/. 
	@$(ECHO_MKDIR) $(@)
	$(NOECHO)mkdir -p $(@)  

.PHONY: $(JAIL_ROOT_DIR)dev/console

$(JAIL_ROOT_DIR)dev/console: | $$(@D)/.
	mknod $(@) c 5 1

.PHONY: kernel
kernel: \
 $(KERNEL_DIR)/.config \
 $(JAIL_ROOT_FS_DIRS)
	$(NOECHO)$(MAKE) -C $(KERNEL_DIR) uImage 

$(KERNEL_DIR)/.config: ./kernel-config
	@$(ECHO_INSTALL) $(KERNEL_DIR)/.config
	$(NOECHO)install -m644 $(<) $(KERNEL_DIR)/.config

$(BUILD_ROOT)jail.cpio: \
 kernel \
 $(addprefix $(BUILD_ROOT)jail/,$(SKELETON_ROOTFS_BARE) $(DROPBEAR_BARE) $(BUSYBOX_BARE) $(STRACE_BARE)) \
 $(addprefix $(JAIL_SYSROOT)/,$(DROPBEAR_BARE) $(ZLIB_BARE)) \
 $(JAIL_ROOT_FS_DIRS) \
 $(JAIL_ROOT_DIR)dev/console \
 $(JAIL_ROOT_DIR)lib/.done \
 $(JAIL_ROOT_DIR)etc/shadow \
 $(JAIL_ROOT_DIR)etc/passwd \
 $(JAIL_ROOT_DIR)etc/group
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)@chown -R root:root $(JAIL_ROOT_DIR)
	-$(NOECHO)$(RM) $(addprefix $(JAIL_ROOT_DIR)lib/,ld-linux-armhf.so.3-so-stripped ld-linux-armhf.so.3 libm.so.6-so libm.so.6-so-stripped)
	$(NOECHO)cd $(JAIL_ROOT_DIR) && find -depth -print0 | cpio -o0 --format=newc > $(shell readlink -f $(@))
	$(NOECHO)$(MAKE) -C $(KERNEL_DIR) modules
	A=$(shell mktemp -d /tmp/tmp-modules.XXXXXXX) && $(MAKE) -C $(KERNEL_DIR) INSTALL_MOD_PATH=$$A INSTALL_MOD_STRIP=1 modules_install && rsync -vax --delete $$A/lib/modules/ $(JAIL_ROOT_DIR)/lib/modules/ && $(RM) -r $$A
	$(NOECHO)$(RM) $(KERNEL_DIR)/usr/initramfs_data.o
	$(NOECHO)$(MAKE) -C $(KERNEL_DIR) uImage dtbs 
	$(NOECHO)$(MAKE) -C $(KERNEL_DIR) uImage-dtb.am335x-bone

$(BUILD_ROOT)jail.tar.gz: \
 $(JAIL_ROOT_DIR)dev/console \
 $(JAIL_ROOT_DIR)lib/.done \
 $(JAIL_ROOT_FS_DIRS) \
 $(addprefix $(JAIL_ROOT_DIR), $(JAIL_BUSYBOX_APPLETS)) \
 $(JAIL_ROOT_DIR)etc/passwd \
 $(JAIL_ROOT_DIR)etc/group
	@$(ECHO_GENERATE) $(@)
	$(NOECHO)tar -C $(JAIL_ROOT_DIR) -czf $(abspath $(@)) .

$(JAIL_ROOT_DIR)lib/.done: | $(MKLIBS_INSTALL_DIR).done 

.PHONY: mklibs
mklibs: $(JAIL_ROOT_DIR)lib/.done
ifeq ($(CROSS_COMPILE),)
$(JAIL_ROOT_DIR)lib/.done: $(ROOTFS_PREQS) | $$(@D)/.
	@$(ECHO_GENERATE) $(@D)
	$(NOECHO)$(MKLIBS_INSTALL_DIR)bin/mklibs -d $(abspath $(@D)) $(^)
	$(NOECHO)touch $(@)
else
$(JAIL_ROOT_DIR)lib/.done: $(ROOTFS_PREQS) 
	@$(ECHO_GENERATE) $(@D)
	$(NOECHO)$(MKLIBS_INSTALL_DIR)bin/mklibs -D \
 $(addprefix -l,$(notdir $(wildcard $(JAIL_SYSROOT)/lib/libnss*-2.17.so))) \
 -L/lib:/usr/local/lib:/usr/lib --libc-extras-dir /usr/lib/libc_pic --sysroot $(JAIL_SYSROOT) \
 -d $(abspath $(@D)) --target=$(CROSS_COMPILE_PREFIX) \
 $(shell find $(BUILD_ROOT)jail/ -type f | xargs file | grep -e 'ELF.*executable' | cut -f1 -d:)
	$(ECHO_STRIP) $(@)
	$(NOECHO)find $(BUILD_ROOT)jail/ -type f | xargs file | grep -e 'ELF.*executable' | cut -f1 -d':' | xargs $(CROSS_COMPILE)strip
	$(NOECHO)touch $(@)
endif

.PHONY: jail-clean
jail-clean:
	$(NOECHO)$(RM) -r $(JAIL_ROOT_DIR)

# Helper target
# Output values of the build system internal variables.
.PHONY: echo

echo:
	@$(ECHO) $(BIWHITE)BUILD_ROOT$(RESET)   $(BUILD_ROOT) 
	@$(ECHO) $(BIWHITE)PATH$(RESET) $(PATH) 
	@$(ECHO) $(BIWHITE)ROOT_CROSS_COMPILE$(RESET)   $(ROOT_CROSS_COMPILE)
	@$(ECHO) $(BIWHITE)JAIL_ROOT_DIR$(RESET)    $(JAIL_ROOT_DIR) 
	@$(ECHO) $(BIWHITE)JAIL_ROOT_FS_DIRS$(RESET)    $(JAIL_ROOT_FS_DIRS) 
	@$(ECHO) $(BIWHITE)JAIL_TOOLCHAINS_HOME$(RESET)   $(JAIL_TOOLCHAINS_HOME)
	@$(ECHO) $(BIWHITE)CROSS_COMPILE$(RESET)   $(CROSS_COMPILE)
	@$(ECHO) $(BIWHITE)CROSS_COMPILE_PREFIX$(RESET)    $(CROSS_COMPILE_PREFIX)
	@$(ECHO) $(BIWHITE)JAIL_TOOLCHAIN_ROOT  $(RESET)  $(JAIL_TOOLCHAIN_ROOT)
	@$(ECHO) $(BIWHITE)JAIL_TOOLCHAIN_PATH  $(RESET)  $(JAIL_TOOLCHAIN_PATH)
	@$(ECHO) $(BIWHITE)JAIL_SYSROOT $(RESET) $(JAIL_SYSROOT)
	@$(ECHO) $(BIWHITE)MKLIBS_ARCH  $(RESET) $(MKLIBS_ARCH)
	@$(ECHO) $(BIWHITE)MKLIBS_TAR   $(RESET) $(MKLIBS_TAR)
	@$(ECHO) $(BIWHITE)MKLIBS_INSTALL_DIR   $(RESET)$(MKLIBS_INSTALL_DIR)
	@$(ECHO) $(BIWHITE)BUSYBOX_PKG_SRC_DIR $(RESET) $(BUSYBOX_PKG_SRC_DIR)
	@$(ECHO) $(BIWHITE)BUSYBOX_ARCH  $(RESET) $(BUSYBOX_ARCH)
	@$(ECHO) $(BIWHITE)BUSYBOX_ARCH_ROOT_DIR    $(RESET) $(BUSYBOX_ARCH_ROOT_DIR)
	@$(ECHO) $(BIWHITE)BUSYBOX_PKG_SRC_DIR  $(RESET) $(BUSYBOX_PKG_SRC_DIR)

# Helper target
# Output values of the build system internal variables.
.PHONY: help

help:
	@$(ECHO) $(ON_BLACK)$(BIWHITE)make echo $(RESET) gets the values of the variables
	@$(ECHO) $(ON_BLACK)$(BIWHITE)make help $(RESET) this rant.

# Clean all the build artifacts
.PHONY: clean
clean:
	@$(ECHO_RM) $(BUILD_ROOT)
	$(NOECHO)$(RM) -r $(BUILD_ROOT)
