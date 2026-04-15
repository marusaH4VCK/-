#import <UIKit/UIKit.h>

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - Enums
// ═══════════════════════════════════════════════════════════════════════════════

typedef NS_ENUM(NSInteger, GMTab) {
    GMTabESP = 0,
    GMTabAimbot,
    GMTabMSL,
    GMTabMISC,
    GMTabUI,
    GMTabSettings
};

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - Color Constants (Only declare, not define)
// ═══════════════════════════════════════════════════════════════════════════════

extern UIColor *GM_BG_DARK;
extern UIColor *GM_BG_LIGHT;
extern UIColor *GM_SIDEBAR_DARK;
extern UIColor *GM_SIDEBAR_LIGHT;
extern UIColor *GM_PILL_DARK;
extern UIColor *GM_PILL_LIGHT;
extern UIColor *GM_ROW_DARK;
extern UIColor *GM_ROW_LIGHT;
extern UIColor *GM_TEXT_DARK;
extern UIColor *GM_TEXT_LIGHT;
extern UIColor *GM_SUBTEXT_DARK;
extern UIColor *GM_SUBTEXT_LIGHT;
extern UIColor *GM_CHECK_BG;
extern UIColor *GM_THUMB_DARK;
extern UIColor *GM_SEG_ACTIVE;

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMToggleRow
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMToggleRow : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL useCircleStyle;
@property (nonatomic, copy) void (^onToggle)(BOOL isOn);
- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                         isOn:(BOOL)isOn
                  circleStyle:(BOOL)circle
                       isDark:(BOOL)dark;
- (void)applyTheme:(BOOL)dark;
@end

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMSliderRow
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMSliderRow : UIView
@property (nonatomic, assign) float value;
@property (nonatomic, copy) void (^onValueChange)(float value);
- (instancetype)initWithTitle:(NSString *)title
                          min:(float)min
                          max:(float)max
                         step:(float)step
                        value:(float)value
                       isDark:(BOOL)dark;
- (void)applyTheme:(BOOL)dark;
@end

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMSegmentRow
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMSegmentRow : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^onSelect)(NSInteger index);
- (instancetype)initWithOptions:(NSArray<NSString *> *)options
                  selectedIndex:(NSInteger)index
                          label:(NSString *)label
                         isDark:(BOOL)dark;
- (void)applyTheme:(BOOL)dark;
@end

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMMenuViewController
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMMenuViewController : UIViewController
@property (nonatomic, assign) BOOL isDark;
+ (instancetype)sharedController;
- (void)show;
- (void)dismiss;
@end

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMMenuWindow
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMMenuWindow : UIWindow
+ (instancetype)sharedWindow;
- (void)show;
- (void)hide;
@end

// ═══════════════════════════════════════════════════════════════════════════════
// MARK: - GMFloatingButton
// ═══════════════════════════════════════════════════════════════════════════════

@interface GMFloatingButton : NSObject
+ (instancetype)sharedButton;
- (void)install;
- (void)toggleMenu;
@end
