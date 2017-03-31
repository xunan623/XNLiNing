//
//  XNShareBtn.m
//  XNLiNing
//
//  Created by xunan on 2017/3/31.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShareBtn.h"

@implementation XNShareBtn

- (instancetype )initWithFrame:(CGRect)frame tilte:(NSString *)title image:(NSString *)imageNamed {
    if (self = [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:XNColor_RGB(50, 50, 50) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;        
        [self setImageEdgeInsets:UIEdgeInsetsMake(-(self.rw_height - self.imageView.frame.size.height),
                                                  0.0, 0.0,
                                                  -self.titleLabel.frame.size.width)];
        // 设置按钮标题偏移
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.imageView.frame.size.width,
                                                  -(self.rw_height - self.titleLabel.frame.size.height),0.0)];
    }
    return self;
}

@end
