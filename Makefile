
# ──────────────────────────────────────────────────────────────────────────────
# Theos Makefile — GameMenuUI tweak
# ──────────────────────────────────────────────────────────────────────────────
#
# วิธีใช้:
#   1. ติดตั้ง Theos  →  https://theos.dev/docs/installation
#   2. export THEOS=/opt/theos
#   3. รัน:   make package   (สร้าง .deb ที่มีทั้ง dylib + Resources/toggle-icon.jpeg)
#   4. ติดตั้ง .deb ผ่าน Filza หรือ:  make install (ถ้า SSH เปิดอยู่)
#
# clang ตรงๆ (ไม่ต้อง Theos):
#   clang -arch arm64 -isysroot $(xcrun --sdk iphoneos --show-sdk-path) \
#         -framework UIKit -framework Foundation \
#         -dynamiclib -fobjc-arc -o GameMenuUI.dylib src/GameMenuUI.m
# ──────────────────────────────────────────────────────────────────────────────

TARGET  := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES := SpringBoard

include $(THEOS)/makefiles/common.mk

# ─── Tweak (hooks into app) ──────────────────────────────────────────────────
TWEAK_NAME := GameMenuUI

GameMenuUI_FILES    := src/GameMenuUI.m Tweak.x
GameMenuUI_CFLAGS   := -fobjc-arc -Wall -Wextra -O2
GameMenuUI_LDFLAGS  := -framework UIKit -framework Foundation -framework QuartzCore

# ─── Bundle resources ────────────────────────────────────────────────────────
# toggle-icon.jpeg จะถูก package ลง .deb และโหลดผ่าน
# [NSBundle bundleForClass:[GMFloatingButton class]]
GameMenuUI_RESOURCE_DIRS := Resources

include $(THEOS_MAKE_PATH)/tweak.mk
