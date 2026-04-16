export THEOS=$(THEOS)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GameMenuUI

GameMenuUI_FILES = Tweak.x src/GameMenuUI.m src/KeyAuthUI_full.mm

GameMenuUI_FRAMEWORKS = UIKit Foundation Metal MetalKit

GameMenuUI_CFLAGS = -fobjc-arc -std=c++17

include $(THEOS_MAKE_PATH)/tweak.mk
