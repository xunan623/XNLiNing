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
    
    return YES;
}


+ (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    RCMessage *message = notification.object;
    
    if (message.messageDirection == MessageDirection_RECEIVE) {
        static NSInteger i = 1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:i];
        i++;
    }
    
}

@end
