export TARGET = iphone:latest:latest
include $(THEOS)/makefiles/common.mk

SOURCES := $(wildcard FLEX/*.m)

TWEAK_NAME = FLEXing
FLEXing_FRAMEWORKS = CoreGraphics UIKit ImageIO QuartzCore
FLEXing_FILES = Tweak.xm $(SOURCES)
FLEXing_LIBRARIES = sqlite3 z activator objcipc
FLEXing_CFLAGS += -fobjc-arc -w

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_STORE" -delete

after-install::
	install.exec "killall -9 SpringBoard"