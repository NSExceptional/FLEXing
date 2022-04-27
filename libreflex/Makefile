export ARCHS = arm64 arm64e
export TARGET = iphone:latest:13.0
include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = Reflex

Reflex_XCODE_PROJECT = Reflex/Reflex.xcodeproj
Reflex_XCODEFLAGS = LD_DYLIB_INSTALL_NAME=/Library/MobileSubstrate/DynamicLibraries/libreflex.dylib
Reflex_XCODEFLAGS += DWARF_DSYM_FOLDER_PATH=$(THEOS_OBJ_DIR)/dSYMs

include $(THEOS_MAKE_PATH)/xcodeproj.mk

SDK_DIR = $(THEOS_PACKAGE_DIR)/Reflex.framework
DSYM_DIR = $(SDK_DIR).dSYM

TWEAK_NAME = libreflex
$(TWEAK_NAME)_FILES = $(SOURCES)
$(TWEAK_NAME)_CFLAGS += -fobjc-arc -w -Wno-unsupported-availability-guard -g

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

# For printing variables from the makefile
print-%  : ; @echo $* = $($*)
