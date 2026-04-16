#import "src/GameMenuUI.h"
#import "src/KeyAuthUI_full.h"

static void (^onLoginBlock)(NSString *) = ^(NSString *key) {
    NSLog(@"[GameMenuUI] Key: %@", key);
};

static void (^onWebsiteBlock)(void) = ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://example.com"]];
};

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        KeyAuthViewController *vc = [KeyAuthViewController new];
        vc.onLogin = onLoginBlock;
        vc.onWebsite = onWebsiteBlock;
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:vc animated:YES completion:nil];
        
        [[GMFloatingButton sharedButton] install];
    });
}
