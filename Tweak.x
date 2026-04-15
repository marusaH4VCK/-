// Tweak.x — inject GameMenuUI into target app
// แก้ bundle ID ในไฟล์ control ให้ตรงกับ app ที่ต้องการ inject

#import "src/GameMenuUI.h"

// ────────────────────────────────────────────────────────────────────────────
// %ctor  รันทันทีเมื่อ dylib ถูกโหลด
// ใช้ Notification เพื่อรอให้ app พร้อมก่อนสร้างปุ่ม
// ────────────────────────────────────────────────────────────────────────────

%ctor {
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidBecomeActiveNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(__unused NSNotification *note) {
        // สร้างปุ่มแค่ครั้งเดียว
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            [[GMFloatingButton sharedButton] install];
        });
    }];
}
