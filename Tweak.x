#import "src/GameMenuUI.h"
#import "src/KeyAuthUI_full.h"

// Helper function to get key window (iOS 13+ compatible)
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
        return nil;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
    }
}

static void (^onLoginBlock)(NSString *) = ^(NSString *key) {
    NSLog(@"[GameMenuUI] Key: %@", key);
};

static void (^onWebsiteBlock)(void) = ^{
    // Fix deprecated openURL
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
    dispatch_async(dispatch_get_main_queue(), ^{
        KeyAuthViewController *vc = [KeyAuthViewController new];
        vc.onLogin = onLoginBlock;
        vc.onWebsite = onWebsiteBlock;
        
        UIWindow *keyWindow = getKeyWindow();
        UIViewController *root = keyWindow.rootViewController;
        [root presentViewController:vc animated:YES completion:nil];
        
        [[GMFloatingButton sharedButton] install];
    });
}
