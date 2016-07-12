export ARCHS = arm64
export TARGET = iphone:9.0:9.0
include theos/makefiles/common.mk

SOURCES := $(wildcard FLEX/*.m)

TWEAK_NAME = FLEXing
FLEXing_FILES = Tweak.xm $(SOURCES)
FLEXing_FRAMEWORKS = UIKit
FLEXing_LDFLAGS += -Wl,-segalign,4000
FLEXing_LIBRARIES = sqlite3 z
FLEXing_CFLAGS += -fobjc-arc -w

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_STORE" -delete
