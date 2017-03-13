//
//  AppDelegate+XNRongIMKit.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XNRongIMKit.h"
#import <RongIMKit/RongIMKit.h>

@implementation AppDelegate (XNRongIMKit)

+ (BOOL)rong_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[RCIM sharedRCIM] initWithAppKey:AppRongCloudAppKey];
    
    [[RCIM sharedRCIM] connectWithToken:AA55_Token success:^(NSString *userId) {
        XNLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        XNLog(@"登陆的错误码为:%zd", status);
    } tokenIncorrect:^{
        XNLog(@"token错误");
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
    
    return YES;
}


- (void)setupRCData {
    self.friendsArray = [[NSMutableArray alloc]init];
}
@end
