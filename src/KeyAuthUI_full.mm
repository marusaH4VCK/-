#import "KeyAuthUI_full.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

extern "C" void KeyAuth_randomKey(char *buf, int len) {
    static int seeded = 0;
    if (!seeded) { srand((unsigned)time(NULL)); seeded = 1; }
    static const char kPool[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int pool = (int)(sizeof(kPool) - 1);
    for (int i = 0; i < len - 1; i++) buf[i] = kPool[rand() % pool];
    buf[len - 1] = '\0';
}

static UIColor *colorBG(void) {
    return [UIColor colorWithRed:0.11f green:0.16f blue:0.28f alpha:1.f];
}
static UIColor *colorCard(void) {
    return [UIColor colorWithRed:0.07f green:0.11f blue:0.20f alpha:0.96f];
}
static UIColor *colorAccent(void) {
    return [UIColor colorWithRed:0.45f green:0.79f blue:1.00f alpha:1.f];
}
static UIColor *colorSub(void) {
    return [UIColor colorWithRed:0.66f green:0.73f blue:0.83f alpha:1.f];
}
static UIColor *colorInputBG(void) {
    return [UIColor colorWithRed:0.05f green:0.08f blue:0.15f alpha:1.f];
}
static UIColor *colorInputBorder(void) {
    return [UIColor colorWithRed:0.17f green:0.29f blue:0.44f alpha:1.f];
}
static UIColor *colorBtnGray(void) {
    return [UIColor colorWithRed:0.29f green:0.39f blue:0.49f alpha:1.f];
}

static UILabel *makeLabel(NSString *text, CGFloat size, BOOL bold, UIColor *color) {
    UILabel *l = [UILabel new];
    l.translatesAutoresizingMaskIntoConstraints = NO;
    l.text = text;
    l.font = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    l.textColor = color;
    l.textAlignment = NSTextAlignmentCenter;
    return l;
}

static UIButton *makePillButton(NSString *title, UIColor *bg, CGFloat radius) {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.translatesAutoresizingMaskIntoConstraints = NO;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    b.backgroundColor = bg;
    b.layer.cornerRadius = radius;
    b.clipsToBounds = YES;
    return b;
}

@interface _KALoadingView : UIView
- (void)animateWithCompletion:(dispatch_block_t)done;
@end

@implementation _KALoadingView {
    UIProgressView  *_bar;
    UILabel         *_pct;
    NSTimer         *_timer;
    float            _progress;
    dispatch_block_t _done;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setupUI];
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)setupUI {
    self.backgroundColor = colorBG();
    UIView *card = [UIView new];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = colorCard();
    card.layer.cornerRadius = 28.f;
    card.layer.borderWidth = 0.5f;
    card.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.12f].CGColor;
    [self addSubview:card];
    
    UIView *logo = [UIView new];
    logo.translatesAutoresizingMaskIntoConstraints = NO;
    logo.layer.cornerRadius = 16.f;
    logo.clipsToBounds = YES;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, 60, 60);
    gl.cornerRadius = 16.f;
    gl.colors = @[(__bridge id)[UIColor colorWithRed:1.f green:0.54f blue:0.16f alpha:1.f].CGColor, (__bridge id)[UIColor colorWithRed:1.f green:0.30f blue:0.55f alpha:1.f].CGColor, (__bridge id)[UIColor colorWithRed:0.36f green:0.49f blue:1.f alpha:1.f].CGColor];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    [logo.layer addSublayer:gl];
    UILabel *ff = makeLabel(@"FF", 22, YES, UIColor.whiteColor);
    [logo addSubview:ff];
    [NSLayoutConstraint activateConstraints:@[[ff.centerXAnchor constraintEqualToAnchor:logo.centerXAnchor], [ff.centerYAnchor constraintEqualToAnchor:logo.centerYAnchor]]];
    UILabel *title = makeLabel(@"Free Fire MAX", 24, YES, UIColor.whiteColor);
    UILabel *sub = makeLabel(@"กำลังตรวจสอบสิทธิ์...", 13, NO, colorSub());
    _bar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _bar.translatesAutoresizingMaskIntoConstraints = NO;
    _bar.progress = 0;
    _bar.progressTintColor = colorAccent();
    _bar.trackTintColor = [UIColor colorWithRed:0.13f green:0.19f blue:0.30f alpha:1.f];
    _bar.layer.cornerRadius = 4.f;
    _bar.clipsToBounds = YES;
    _pct = makeLabel(@"0%", 12, NO, colorAccent());
    _pct.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightMedium];
    _pct.textAlignment = NSTextAlignmentRight;
    [card addSubview:logo];
    [card addSubview:title];
    [card addSubview:sub];
    [card addSubview:_bar];
    [card addSubview:_pct];
    [NSLayoutConstraint activateConstraints:@[
        [card.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [card.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [card.widthAnchor constraintEqualToConstant:300.f],
        [logo.topAnchor constraintEqualToAnchor:card.topAnchor constant:26.f],
        [logo.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [logo.widthAnchor constraintEqualToConstant:60.f],
        [logo.heightAnchor constraintEqualToConstant:60.f],
        [title.topAnchor constraintEqualToAnchor:logo.bottomAnchor constant:14.f],
        [title.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4.f],
        [sub.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [_bar.topAnchor constraintEqualToAnchor:sub.bottomAnchor constant:20.f],
        [_bar.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24.f],
        [_bar.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24.f],
        [_bar.heightAnchor constraintEqualToConstant:6.f],
        [_pct.topAnchor constraintEqualToAnchor:_bar.bottomAnchor constant:6.f],
        [_pct.trailingAnchor constraintEqualToAnchor:_bar.trailingAnchor],
        [_pct.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-22.f],
    ]];
}

- (void)animateWithCompletion:(dispatch_block_t)done {
    _done = [done copy];
    _progress = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.034 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick {
    _progress += 2.f;
    if (_progress >= 100.f) {
        _progress = 100.f;
        [_timer invalidate];
        _timer = nil;
        [_bar setProgress:1.f animated:YES];
        _pct.text = @"100%";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28 * NSEC_PER_SEC)), dispatch_get_main_queue(), _done);
        return;
    }
    [_bar setProgress:_progress / 100.f animated:YES];
    _pct.text = [NSString stringWithFormat:@"%.0f%%", _progress];
}
@end

@interface _KAKeyInputView : UIView
@property (nonatomic, copy) void (^onLogin)(NSString *);
@property (nonatomic, copy) void (^onWebsite)(void);
@end

@implementation _KAKeyInputView {
    UITextField *_field;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setupUI];
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)setupUI {
    self.backgroundColor = colorBG();
    char buf[19]; KeyAuth_randomKey(buf, 19);
    NSString *rk = [NSString stringWithUTF8String:buf];
    UIView *card = [UIView new];
    card.translatesAutoresizingMaskIntoConstraints = NO;
    card.backgroundColor = colorCard();
    card.layer.cornerRadius = 24.f;
    card.layer.borderWidth = 0.5f;
    card.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.10f].CGColor;
    card.alpha = 0;
    card.transform = CGAffineTransformMakeScale(0.92f, 0.92f);
    [self addSubview:card];
    UILabel *title = makeLabel(@"Free Fire MAX", 24, YES, colorAccent());
    UILabel *sub = makeLabel(@"請輸入您的金鑰", 13, NO, colorSub());
    _field = [UITextField new];
    _field.translatesAutoresizingMaskIntoConstraints = NO;
    _field.text = rk;
    _field.font = [UIFont monospacedSystemFontOfSize:14 weight:UIFontWeightRegular];
    _field.textColor = UIColor.whiteColor;
    _field.backgroundColor = colorInputBG();
    _field.layer.cornerRadius = 12.f;
    _field.layer.borderWidth = 1.f;
    _field.layer.borderColor = colorInputBorder().CGColor;
    _field.clipsToBounds = YES;
    UIView *lp = [[UIView alloc] initWithFrame:CGRectMake(0,0,14,0)];
    UIView *rp = [[UIView alloc] initWithFrame:CGRectMake(0,0,14,0)];
    _field.leftView = lp;
    _field.leftViewMode = UITextFieldViewModeAlways;
    _field.rightView = rp;
    _field.rightViewMode = UITextFieldViewModeAlways;
    _field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"金鑰" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    UIButton *btnWeb = makePillButton(@"網站", colorBtnGray(), 22.f);
    UIButton *btnLogin = makePillButton(@"登入", colorAccent(), 22.f);
    [btnLogin setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnWeb addTarget:self action:@selector(tapWeb) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin addTarget:self action:@selector(tapLogin) forControlEvents:UIControlEventTouchUpInside];
    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[btnWeb, btnLogin]];
    row.translatesAutoresizingMaskIntoConstraints = NO;
    row.axis = UILayoutConstraintAxisHorizontal;
    row.distribution = UIStackViewDistributionFillEqually;
    row.spacing = 12.f;
    [card addSubview:title];
    [card addSubview:sub];
    [card addSubview:_field];
    [card addSubview:row];
    [NSLayoutConstraint activateConstraints:@[
        [card.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [card.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [card.widthAnchor constraintEqualToConstant:300.f],
        [title.topAnchor constraintEqualToAnchor:card.topAnchor constant:20.f],
        [title.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4.f],
        [sub.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [_field.topAnchor constraintEqualToAnchor:sub.bottomAnchor constant:16.f],
        [_field.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.f],
        [_field.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.f],
        [_field.heightAnchor constraintEqualToConstant:46.f],
        [row.topAnchor constraintEqualToAnchor:_field.bottomAnchor constant:14.f],
        [row.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16.f],
        [row.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16.f],
        [row.heightAnchor constraintEqualToConstant:44.f],
        [row.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-20.f],
    ]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.72f initialSpringVelocity:0.4f options:0 animations:^{
            card.alpha = 1.f;
            card.transform = CGAffineTransformIdentity;
        } completion:nil];
    });
}

- (void)tapLogin { if (self.onLogin) self.onLogin(_field.text); }
- (void)tapWeb { if (self.onWebsite) self.onWebsite(); }
@end

@implementation KeyAuthViewController {
    _KALoadingView *_loadView;
    _KAKeyInputView *_keyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = colorBG();
    _loadView = [[_KALoadingView alloc] init];
    _loadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loadView];
    [NSLayoutConstraint activateConstraints:@[
        [_loadView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_loadView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [_loadView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_loadView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
    __weak __typeof(self) weak = self;
    [_loadView animateWithCompletion:^{ [weak showKeyInput]; }];
}

- (void)showKeyInput {
    _keyView = [[_KAKeyInputView alloc] init];
    _keyView.translatesAutoresizingMaskIntoConstraints = NO;
    _keyView.onLogin = self.onLogin;
    _keyView.onWebsite = self.onWebsite;
    [self.view addSubview:_keyView];
    [NSLayoutConstraint activateConstraints:@[
        [_keyView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_keyView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [_keyView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_keyView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
    [UIView animateWithDuration:0.3f animations:^{
        self->_loadView.alpha = 0;
    } completion:^(BOOL _) {
        [self->_loadView removeFromSuperview];
    }];
}
@end
