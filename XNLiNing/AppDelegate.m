//
//  AppDelegate.m
//  XNLiNing
//
//  Created by xunan on 16/9/10.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "AppDelegate.h"
#import "XNLoginController.h"
#import "AppDelegate+Reachability.h"
#import "XNUserDefaults.h"
#import "UIWindow+Extension.h"
#import "AppDelegate+XNRongIMKit.h"
#import "AppDelegate+XNBaiduLocation.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+XN3DTouch.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate+XNThirdPlatform.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 本地存储
    [[RWUserDefaults shareInstance] registerClass:[XNUserDefaults class]];
    
    // 融云相关
    [AppDelegate rong_application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 3dTouch
    [AppDelegate touch_application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 第三方登录
    [self registThirdPlatform];
    
    // 百度地图初始化
    [self baiduLocation_applicationSetUp];
    
    // 检查网络
    [self reachabilityInternet];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 切换控制器
    [self.window switchRootViewController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
    
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
}

//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/**
 * 远程推送的token
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
/**
 * 远程推送的内容
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    [AppDelegate rong_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
/**
 * 本地推送的内容
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [AppDelegate rong_application:application didReceiveLocalNotification:notification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
    
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    [AppDelegate touch_application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
    
    if([shortcutItem.type isEqualToString:@"com.aist.XNLiNing"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

@end
