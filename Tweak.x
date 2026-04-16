#import "src/GameMenuUI.h"
#import "src/KeyAuthUI_full.h"

static UIWindow *getKeyWindow(void) {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
                return windowScene.windows.firstObject;
            }
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
}

static void (^onLoginBlock)(NSString *) = ^(NSString *key) {
    NSLog(@"[GameMenuUI] ✅ Key entered: %@", key);
    // TODO: ตรวจสอบ key ที่นี่
};

static void (^onWebsiteBlock)(void) = ^{
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
};

%ctor {
    NSLog(@"[GameMenuUI] 🔧 Tweak loaded, waiting for app...");
    
    // รอให้แอพพร้อมก่อน (0.5 วินาที)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = getKeyWindow();
        UIViewController *root = keyWindow.rootViewController;
        
        if (root) {
            NSLog(@"[GameMenuUI] ✅ Presenting KeyAuth UI");
            KeyAuthViewController *vc = [KeyAuthViewController new];
            vc.onLogin = onLoginBlock;
            vc.onWebsite = onWebsiteBlock;
            [root presentViewController:vc animated:YES completion:nil];
        } else {
            NSLog(@"[GameMenuUI] ❌ rootViewController is nil, retrying...");
            // ถ้ายังไม่มี root ให้ลองอีกที
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow *kw = getKeyWindow();
                UIViewController *r = kw.rootViewController;
                if (r) {
                    KeyAuthViewController *vc = [KeyAuthViewController new];
                    vc.onLogin = onLoginBlock;
                    vc.onWebsite = onWebsiteBlock;
                    [r presentViewController:vc animated:YES completion:nil];
                }
            });
        }
        
        // โหลดปุ่มลอย
        [[GMFloatingButton sharedButton] install];
    });
}
