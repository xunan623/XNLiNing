//
//  UIView+EasyShow.m
//  RPAntus
//
//  Created by Crz on 15/11/21.
//  Copyright © 2015年 Ranger. All rights reserved.
//

#import "UIView+EasyShow.h"

@implementation UIView (EasyShow)

- (void)setRw_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)rw_x {
    return self.frame.origin.x;
}

- (void)setRw_left:(CGFloat)x {
    [self setRw_x:x];
}

- (CGFloat)rw_left {
    return self.frame.origin.x;
}

- (void)setRw_maxX:(CGFloat)maxX {
    self.rw_x = maxX - self.rw_width;
}

- (CGFloat)rw_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setRw_right:(CGFloat)maxX {
    [self setRw_maxX:maxX];
}

- (CGFloat)rw_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRw_maxY:(CGFloat)maxY {
    self.rw_y = maxY - self.rw_height;
}

- (CGFloat)rw_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setRw_bottom:(CGFloat)maxY {
    [self setRw_maxX:maxY];
}

- (CGFloat)rw_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setRw_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)rw_y {
    return self.frame.origin.y;
}

- (void)setRw_top:(CGFloat)y {
    [self setRw_y:y];
}

- (CGFloat)rw_top {
    return self.frame.origin.y;
}

- (void)setRw_centerX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)rw_centerX {
    return self.center.x;
}

- (void)setRw_centerY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)rw_centerY {
    return self.center.y;
}

- (void)setRw_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)rw_width {
    return self.frame.size.width;
}

- (void)setRw_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)rw_height {
    return self.frame.size.height;
}

- (CGPoint)rw_origin {
    return self.frame.origin;
}

- (void)setRw_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setRw_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)rw_size {
    return self.frame.size;
}

- (void)setRw_cornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = radius > 0;
}

- (CGFloat)rw_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)rw_round {
    [self setRw_cornerRadius:self.frame.size.height/2];
}

@end

#pragma mark-  XibHelper

@implementation UIView (XibHelper)

+ (instancetype)rw_viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}



- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}



- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


@end

