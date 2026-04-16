#ifndef KEYAUTHUI_FULL_H
#define KEYAUTHUI_FULL_H

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif

void KeyAuth_randomKey(char *buf, int len);

#ifdef __cplusplus
}
#endif

@interface KeyAuthViewController : UIViewController
@property (nonatomic, copy) void (^onLogin)(NSString *key);
@property (nonatomic, copy) void (^onWebsite)(void);
@end

#endif
