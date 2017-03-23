//
//  AppDelegate+XNRongIMKit.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XNRongIMKit.h"
#import <RongIMKit/RongIMKit.h>
#import "RCUserInfo+XNAddition.h"


@implementation AppDelegate (XNRongIMKit)

+ (BOOL)rong_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[RCIM sharedRCIM] initWithAppKey:AppRongCloudAppKey];
    
    // 1.获取token
    [[XNRCDataManager shareManager] getUserRCTokenWithBlock:^(BOOL getTokenResult) {
        if (getTokenResult) {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:RCIM_TOKEN];
            
            RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[XNUserDefaults new].userName
                                                                  name:[XNUserDefaults new].userName
                                                              portrait:@"https://www.baidu.com/img/baidu_jgylogo3.gif"
                                                                    QQ:@"1246334518"
                                                                   sex:@"男"];
            // 2.登录融云
            [[XNRCDataManager shareManager] loginRongCloudWithUserInfo:myselfInfo withToken:token];
            
        } else {
            XNLog(@"获取token失败");
        }
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
