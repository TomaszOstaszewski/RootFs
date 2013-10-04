# mklibs.mk
# @brief Installs the mklibs utility in the build root directory
# @attention Requires the BUILD_ROOT variable to be defined 
.DEFAULT_GOAL   :=pkg
NOECHO			:=@
BUILD_ROOT		?=build/
PKG_SRC_DIR		:=$(BUILD_ROOT)src/
MKLIBS_VERSION	:=mklibs-0.1.34
MKLIBS_ARCH		:=./$(MKLIBS_VERSION).tar
MKLIBS_BIN_PATH	:=$(MKLIBS_INSTALL_DIR)bin/
FILE_LIST		:=$(shell tar -tf $(MKLIBS_ARCH))
BUILD_FILE_LIST	:=$(addprefix $(PKG_SRC_DIR),$(FILE_LIST))

.SECONDEXPANSION:

.PHONY: file-list

file-list:
	@echo $(sort $(FILE_LIST))
	@echo $(firstword $(sort $(FILE_LIST)))
.PHONY: pkg

MKLIBS_INSTALLED_FILES:= \
 $(MKLIBS_INSTALL_DIR)/bin/mklibs \
 $(MKLIBS_INSTALL_DIR)/bin/mklibs-copy \
 $(MKLIBS_INSTALL_DIR)/bin/mklibs-readelf \
 $(MKLIBS_INSTALL_DIR)/share \
 $(MKLIBS_INSTALL_DIR)/lib/mklibs/python/mklibs/__init__.py \
 $(MKLIBS_INSTALL_DIR)/lib/mklibs/python/mklibs/utils/__init__.py \
 $(MKLIBS_INSTALL_DIR)/lib/mklibs/python/mklibs/utils/logging.py \
 $(MKLIBS_INSTALL_DIR)/lib/mklibs/python/mklibs/utils/main.py \

pkg: $(MKLIBS_INSTALLED_FILES)

$(MKLIBS_INSTALLED_FILES): $(BUILD_FILE_LIST) | $(MKLIBS_INSTALL_DIR)/.
	@cd $(PKG_SRC_DIR)$(MKLIBS_VERSION); ./configure --prefix=$(abspath $(MKLIBS_INSTALL_DIR)) -q; $(MAKE) -s install

.PHONY: src
src : $(BUILD_FILE_LIST)

$(BUILD_FILE_LIST): $(MKLIBS_ARCH) | $(PKG_SRC_DIR)/.
	@tar -C $(PKG_SRC_DIR) -xf $(abspath $(MKLIBS_ARCH)) $(patsubst $(PKG_SRC_DIR)%,,$(@))

include autodir.mk

