// Tweak.x

#import "src/GameMenuUI.h"

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GMFloatingButton sharedButton] install];
        [[GMMenuWindow sharedWindow] show];
        NSLog(@"===== Menu Shown =====");
    });
}
