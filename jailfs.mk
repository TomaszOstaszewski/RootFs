.DEFAULT_GOAL:=all
.PHONY: clean lib bbox
.SECONDEXPANSION:

USER_NAME       :=peon
USER_PASSWORD   :=peon
ROOT_CC	        :=$(ROOT_CROSS_COMPILE)gcc
JAIL_CC	        :=$(JAIL_CROSS_COMPILE)gcc
SYSROOT         ?=/home/tomek/x-tools/i686-unknown-linux-gnu/i686-unknown-linux-gnu/sysroot/

JAIL_ROOT_FS_DIRS:=$(addprefix $(TARGET),\
 $(sort \
 bin \
 dev \
 etc \
 home/$(USER_NAME) \
 lib \
 mnt \
 proc \
 root \
 sbin \
 tmp \
 usr/bin \
 usr/sbin \
 usr/lib \
 var/run \
 var/log
))

$(TARGET)etc/passwd: | $$(@D)/.
	@echo 'peon:x:0:0:peon:/home/peon:/bin/sh' > $(@)
	@chmod --reference=$(subst $(TARGET),/,$(@)) $(@)

