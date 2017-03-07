//
//  XNAlertView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNAlertView.h"

static CGFloat ViewHeight = 64;

@interface XNAlertView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XNAlertView

+ (instancetype)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (XNAlertView *)subview;
        }
    }
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self __initSelf];
        [self setupSubViews];
    }
    return self;
}

+ (instancetype)setupAlertView {
    return [[self alloc] init];
}

+ (void)showWithTitle:(NSString *)title {
    [XNAlertView showWithTitle:title delayHide:1.5 done:nil];
}

+ (void)showWithTitle:(NSString *)title done:(dispatch_block_t)block {
    [XNAlertView showWithTitle:title delayHide:1.5 done:block];
}

+ (void)showWithTitle:(NSString *)title delayHide:(NSTimeInterval)delay done:(dispatch_block_t)block {
    XNAlertView *hud = [self setupAlertView];
    [hud setTitle:title];
    [hud show];
    [hud hideAfterTimerInterval:delay done:block];
}

#pragma mark - utils

- (void)__initSelf {
    self.frame = (CGRect){0, -ViewHeight, CGSizeZero};
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0;
}

- (void)setupSubViews {
    [self addSubview:self.contentView];
    [_contentView addSubview:self.titleLabel];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.alpha = 1.0;
        self.frame = CGRectMake(0, 0, XNScreen_Width, ViewHeight);
    } completion:nil];
    
}

- (void)hide {
    [self hideAfterTimerInterval:0.0 done:nil];
}


- (void)hideAfterTimerInterval:(NSTimeInterval)timerInterval done:(dispatch_block_t)block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timerInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
            self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -ViewHeight);
        } completion:^(BOOL finished) {
            block();
            [self removeFromSuperview];
        }];
    });
}
#pragma mark - Setting && Getting

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XNScreen_Width, ViewHeight)];
        _contentView.backgroundColor = XNColor_RGB(0, 193, 222);
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, XNScreen_Width, 44)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _titleLabel.text = title;
    
}

@end
