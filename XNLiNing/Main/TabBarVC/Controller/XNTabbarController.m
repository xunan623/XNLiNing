//
//  XNTabbarController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNTabbarController.h"
#import "XNBaseNavigationController.h"
#import "XNSettingController.h"
#import "XNTaskController.h"
#import "XNDatabaseService.h"
#import "XNMessageListController.h"
#import "XNHomeGoodsController.h"
#import "XNShopCartController.h"

@interface XNTabbarController ()<UITabBarControllerDelegate>

@end

@implementation XNTabbarController

/**
 *  当第一次调用的时候用
 */
+ (void)initialize
{
    // 通过appearance统一设置所有UITabbarItem文字属性
    // 后面带有 UI_APPEARANCE_SELECTOR的方法,都可以通过appearance统一设置属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = XNAPPNormalColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [XNDatabaseService openDB];
    
    [self setupChildVC:[[XNHomeGoodsController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_homeSelected"];
    XNMessageListController *messageVC = [[XNMessageListController alloc] init];
    [messageVC initData];
    [self setupChildVC:messageVC title:@"消息" image:@"tabbar_message" selectedImage:@"tabbar_messageSelected"];
    [self setupChildVC:[[XNTaskController alloc] init] title:@"分类" image:@"tabbar_task" selectedImage:@"tabbar_taskSelected"];
    [self setupChildVC:[[XNShopCartController alloc] init] title:@"购物车" image:@"tabbar_shop" selectedImage:@"tabbar_shop_selected"];
    [self setupChildVC:[[XNSettingController alloc] init] title:@"我的" image:@"tabbar_setting" selectedImage:@"tabbar_settingSelected"];
    
}

/**
 *  设置自控制器
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 包装一个导航控制器,添加导航控制器为tabbarContoller的自控制器
    XNBaseNavigationController *nav = [[XNBaseNavigationController alloc] initWithRootViewController:vc];
    // 添加为自控制权
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self tabBarButtonClick:[self getTabBarButton]];
}


- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.2,@0.8,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

@end
