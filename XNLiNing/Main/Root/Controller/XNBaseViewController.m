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

- (XNBaseNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[XNBaseNavigationBar alloc] init];
        [_navBar setBackButtonHidden:![self.navigationController.viewControllers indexOfObject:self]];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XNAPPNormalBGColor;
    
}

- (void)setupBase {
    
}

- (void)setNavBarHidden:(BOOL)hidden {
    self.navBar.hidden = hidden;
}

- (void)setNavTitle:(NSString *)title {
    self.navBar.titleLabel.text = title;
}

#pragma mark - 手势返回相关

- (BOOL)gestureRecognizerShouldBegin {
    return YES;
}



#pragma mark 动画相关

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
- (IBAction)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
