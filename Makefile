export TARGET = iphone:9.0:9.0
include $(THEOS)/makefiles/common.mk

# FULL PATH of the FLEX repo on your own machine
FLEX_ROOT = /Users/tanner/Repos/FLEX

# Function to convert /foo/bar to -I/foo/bar
dtoim = $(foreach d,$(1),-I$(d))

# Gather FLEX sources
SOURCES = $(shell find $(FLEX_ROOT)/Classes -name '*.m')
# Gather FLEX headers for search paths
_IMPORTS =  $(shell /bin/ls -d $(FLEX_ROOT)/Classes/*/)
_IMPORTS += $(shell /bin/ls -d $(FLEX_ROOT)/Classes/*/*/)
IMPORTS = -I$(FLEX_ROOT)/Classes/ $(call dtoim, $(_IMPORTS))

TWEAK_NAME = FLEXing
FLEXing_FRAMEWORKS = CoreGraphics UIKit ImageIO QuartzCore
FLEXing_PRIVATE_FRAMEWORKS = AppSupport
FLEXing_FILES = Tweak.xm FLEXNotificationCenter.m $(SOURCES)
FLEXing_LIBRARIES = sqlite3 z activator
FLEXing_CFLAGS += -fobjc-arc -w $(IMPORTS)

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"

# For printing variables from the makefile
print-%  : ; @echo $* = $($*)

