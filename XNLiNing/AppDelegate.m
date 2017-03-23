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
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate+XN3DTouch.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[RWUserDefaults shareInstance] registerClass:[XNUserDefaults class]];
    
    [AppDelegate rong_application:application didFinishLaunchingWithOptions:launchOptions];
        
    [AppDelegate touch_application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self reachabilityInternet];
    
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window switchRootViewController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
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
