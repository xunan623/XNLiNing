//
//  XNAlertView.h
//  XNLiNing
//
//  Created by xunan on 2017/3/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNAlertView : UIView

@property (nonatomic, copy) NSString *title;


+ (void)showWithTitle:(NSString *)title;

+ (void)showWithTitle:(NSString *)title done:(dispatch_block_t)block;

+ (void)showWithTitle:(NSString *)title delayHide:(NSTimeInterval)delay done:(dispatch_block_t)block;

@end
