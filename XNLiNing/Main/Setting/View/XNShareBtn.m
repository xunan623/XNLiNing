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
   
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.7;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.7;
    return CGRectMake(0, 0, imageW, imageH);
}

@end
