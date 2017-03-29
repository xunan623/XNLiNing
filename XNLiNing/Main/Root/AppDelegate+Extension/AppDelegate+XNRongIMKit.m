//
//  AppDelegate+XNRongIMKit.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XNRongIMKit.h"
#import <RongIMKit/RongIMKit.h>
#import "XNChatSystemMessage.h"
#import "XNTabbarController.h"
#import "XNChatController.h"
#import "XNBaseNavigationController.h"
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>
#import <RongIMLib/RongIMLib.h>



@implementation AppDelegate (XNRongIMKit)

+ (BOOL)rong_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[RCIM sharedRCIM] initWithAppKey:AppRongCloudAppKey];
    
    [[RCIM sharedRCIM] setDisableMessageAlertSound:NO];
    [[RCIM sharedRCIM] setDisableMessageNotificaiton:NO];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:[XNRCDataManager shareManager]];
    [[RCIM sharedRCIM] registerMessageType:[XNChatSystemMessage class]];
    
    [[XNRCDataManager shareManager] getTokenAndLoginRCIM:^(BOOL isSuccess) {
        if (isSuccess) {
            XNLog(@"链接成功");
        }
        [[XNRCDataManager shareManager] refreshBadgeValue];
    }];
    
#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    // 注册苹果推送，申请推送权限。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceiveMessageNotification:)
                                                name:RCKitDispatchMessageNotification
                                              object:nil];
    
    
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    // 处理退出后通知的点击，程序启动后获取通知对象，如果是首次启动还没有发送通知，那第一次通知对象为空，没必要去处理通知（如跳转到指定页面）
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        UILocalNotification *localNotifi = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [self changeLocalNotifi:localNotifi];
    }
    XNLog(@"%@--远程推送内容", remoteNotificationUserInfo);
    

    return YES;
}

+ (void)changeLocalNotifi:(UILocalNotification *)localNotifi{
    // 如果在前台直接返回
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    // 获取通知信息
    NSString *selectIndex = localNotifi.userInfo[@"selectIndex"];
    
    // 获取根控制器TabBarController
    XNTabbarController *rootController = (XNTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    // 跳转到指定控制器
    rootController.selectedIndex = [selectIndex intValue];
}


+ (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    RCMessage *message = notification.object;
    
    if (message.messageDirection == MessageDirection_RECEIVE) {
        static NSInteger i = 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:i];
        i++;
    }
    
}

+ (void)rong_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *notMess = [[notification.userInfo objectForKey:RCIM_LOCATIONPUSH_CONTENT] objectForKey:RCIM_LOCATIONPUSH_ID];
    
    if (notMess.length > 0) {
        //判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
        if (application.applicationState != UIApplicationStateActive) {
            
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[XNTabbarController class]]) {
                
                XNChatController *conversationVC = [[XNChatController alloc] init];
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = notMess;
                conversationVC.title = notMess;
         
                XNTabbarController *tabbar = (XNTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabbar.selectedIndex = 1;
                XNBaseNavigationController *nav = tabbar.viewControllers[1];
                [nav pushViewController:conversationVC animated:NO];
                
                // 更新显示的徽章个数
                NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
                badge--;
                badge = badge >= 0 ? badge : 0;
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            } else {
                
            }
        }
    }

}


// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime Message:(NSString *)message sendUserId:(NSString *)sendUserId unReadCount:(NSInteger)index{
    
    UILocalNotification *localNotifi = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    localNotifi.fireDate = fireDate;
    // 时区
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    localNotifi.repeatInterval = kCFCalendarUnitEra;
    localNotifi.repeatInterval = 0;
    
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知内容
    localNotifi.alertBody =  message;
    localNotifi.applicationIconBadgeNumber = index;
    index ++;
    // 通知参数
    NSDictionary *userDict = @{RCIM_LOCATIONPUSH_ID : sendUserId};
    NSDictionary *sumUserDict = @{RCIM_LOCATIONPUSH_CONTENT : userDict};
    localNotifi.userInfo = sumUserDict;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}

@end
