//
//  AppDelegate+XNRongIMKit.h
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XNRongIMKit)

+ (BOOL)rong_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/** 本地推送 */
+ (void)changeLocalNotifi:(UILocalNotification *)localNotifi;

/** 本地通知 */
+ (void)rong_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

/** 注册本地通知 */
+ (void)registerLocalNotification:(NSInteger)alertTime Message:(NSString *)message sendUserId:(NSString *)sendUserId unReadCount:(NSInteger)index;
@end
