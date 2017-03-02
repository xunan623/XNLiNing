//
//  XNBaseViewController.h
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNLoginTranslation.h"

@interface XNBaseViewController : UIViewController<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIButton *presentBtn;
@property (strong, nonatomic) XNLoginTranslation* login;

/** 停止动画 */
- (void)finishAnimationWithBtn:(UIButton *)presentBtn Delay:(NSTimeInterval)time;
@end
