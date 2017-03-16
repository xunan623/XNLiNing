//
//  XNBaseViewController.h
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNLoginTranslation.h"
#import "XNBaseNavigationBar.h"

@interface XNBaseViewController : UIViewController<UIViewControllerTransitioningDelegate>

/** 动画相关 */
@property (strong, nonatomic) UIButton *presentBtn;
@property (strong, nonatomic) XNLoginTranslation* login;
- (void)finishAnimationWithBtn:(UIButton *)presentBtn Delay:(NSTimeInterval)time;



// 默认返回为YES,表示支持右滑返回  手势返回
- (BOOL)gestureRecognizerShouldBegin;
@end
