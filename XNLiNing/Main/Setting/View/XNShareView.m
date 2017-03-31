//
//  XNShareView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/31.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShareView.h"
#import "XNShareBtn.h"

@interface XNShareView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *titleText;

@end

@implementation XNShareView

+ (instancetype)msGetInstance {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *titleArray = @[@"QQ", @"朋友圈", @"微信好友", @"微博"];
    NSArray *imageArray = @[@"Share_QQ", @"Share_WeFriend", @"Share_WeChat", @"Share_Sina"];
    for (NSInteger i = 0 ; i< titleArray.count; i++) {
        XNShareBtn *btn = [[XNShareBtn alloc] initWithFrame:CGRectMake(i * XNScreen_Width/titleArray.count,
                                                                       50, XNScreen_Width/titleArray.count,
                                                                       80)
                                                      tilte:titleArray[i]
                                                      image:imageArray[i]];
        btn.tag = (i+ 1) * 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.centerView addSubview:btn];
    }
    // 标题
    [self.centerView addSubview:self.titleText];
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, XNScreen_Width, XNScreen_Height);
    
    [self addSubview:self.bgView];
    [self addSubview:self.centerView];
}

#pragma mark - Show && Hide 
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        [self.centerView setFrame:CGRectMake(0, XNScreen_Height - 150, XNScreen_Width, 150)];
    }completion:^(BOOL finished) {
        [self layoutSubviews];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.centerView.frame = CGRectMake(0, XNScreen_Height, XNScreen_Width, 0.1);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Touch
- (void)tapBgView:(UITapGestureRecognizer *)tap {
    [self hide];
}

- (void)btnClick:(XNShareBtn *)btn {
    [self hide];
    XNShareType type = btn.tag;
    switch (type) {
        case XNShareTypeQQ: {
            
        }
            break;
        case XNShareTypeWeChatFriend: {
            
        }
            break;
        case XNShareTypeWeChatFriends: {
            
        }
            break;
        case XNShareTypeWeiBo: {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - Setting & Getting

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
        [_bgView addGestureRecognizer:tap];
        _bgView.alpha = 0.2;
    }
    return _bgView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, XNScreen_Height, XNScreen_Width, 0.1)];
        _centerView.backgroundColor = [UIColor whiteColor];
        
    }
    return _centerView;
}

- (UILabel *)titleText {
    if (!_titleText) {
        _titleText = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, XNScreen_Width - 20, 20)];
        _titleText.textColor = XNColor_RGB(50, 50, 50);
        _titleText.font = [UIFont systemFontOfSize:16.f];
        _titleText.textAlignment = NSTextAlignmentCenter;
        _titleText.text = @"请选择你的分享";
    }
    return _titleText;
}



@end
