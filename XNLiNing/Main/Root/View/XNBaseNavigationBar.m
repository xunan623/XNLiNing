//
//  XNBaseNavigationBar.m
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseNavigationBar.h"

@interface XNBaseNavigationBar()


@end

@implementation XNBaseNavigationBar

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, XNScreen_Width, 64);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = XNAPPNormalColor;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.backButton];
}

#pragma mark - Setting & Getting
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, XNScreen_Width - 200, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
        _backButton.hidden = YES;
        [_backButton setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)backClick:(UIButton *)backBtn {
    UIViewController *vc = [self viewController];
    [vc.navigationController popViewControllerAnimated:YES];
}

@end
