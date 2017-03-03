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
#import "XNContactListController.h"
#import "XNTaskController.h"
#import "XNChatListController.h"

@interface XNTabbarController ()

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
    
    [self setupChildVC:[[XNContactListController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_homeSelected"];
    [self setupChildVC:[[XNChatListController alloc] init] title:@"消息" image:@"tabbar_message" selectedImage:@"tabbar_messageSelected"];
    [self setupChildVC:[[XNTaskController alloc] init] title:@"任务" image:@"tabbar_task" selectedImage:@"tabbar_taskSelected"];
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


@end
