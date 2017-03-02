//
//  XNBaseViewController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseViewController.h"

@interface XNBaseViewController ()

@end

@implementation XNBaseViewController

- (XNLoginTranslation *)login {
    if (!_login) {
        _login = [[XNLoginTranslation alloc] initWithView:self.presentBtn];
        
    }
    return _login;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XNAPPNormalBGColor;

}

- (void)finishAnimationWithBtn:(UIButton *)presentBtn Delay:(NSTimeInterval)time {
    self.presentBtn = presentBtn;
    [self.login performSelector:@selector(stopAnimation) withObject:nil afterDelay:time];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.login.reverse = YES;
    return self.login;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.login.reverse = NO;
    return self.login;
}


@end
