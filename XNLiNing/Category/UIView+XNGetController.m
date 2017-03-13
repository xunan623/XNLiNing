//
//  UIView+XNGetController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "UIView+XNGetController.h"

@implementation UIView (XNGetController)

- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}

@end
