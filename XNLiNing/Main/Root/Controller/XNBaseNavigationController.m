//
//  XNBaseNavigationController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseNavigationController.h"
#import "XNBaseViewController.h"

@interface XNBaseNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL enableRightGesture;

@end

@implementation XNBaseNavigationController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTintColor:[UIColor whiteColor]];

    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setBarTintColor:XNAPPNormalColor];
    [bar setAlpha:1];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon-back"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    self.enableRightGesture = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
}






- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.topViewController isKindOfClass:[XNBaseViewController class]]) {
        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            XNBaseViewController *vc = (XNBaseViewController *)self.topViewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    }
    
    return self.enableRightGesture;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[XNBaseViewController class]]) {
        if ([viewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
            XNBaseViewController *vc = (XNBaseViewController *)viewController;
            self.enableRightGesture = [vc gestureRecognizerShouldBegin];
        }
    }
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
    
  
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {

    self.enableRightGesture = YES;
    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        self.enableRightGesture = YES;
    } else {
        NSUInteger index = self.viewControllers.count - 2;
        UIViewController *destinationController = [self.viewControllers objectAtIndex:index];
        if ([destinationController isKindOfClass:[XNBaseViewController class]]) {
            if ([destinationController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                XNBaseViewController *vc = (XNBaseViewController *)destinationController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        }
    }
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        self.enableRightGesture = YES;
    } else {
        UIViewController *destinationController = viewController;
        if ([destinationController isKindOfClass:[XNBaseViewController class]]) {
            if ([destinationController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
                XNBaseViewController *vc = (XNBaseViewController *)destinationController;
                self.enableRightGesture = [vc gestureRecognizerShouldBegin];
            }
        }
    }
    
    return [super popToViewController:viewController animated:animated];
}


@end
