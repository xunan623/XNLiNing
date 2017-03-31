//
//  AppDelegate+XN3DTouch.m
//  XNLiNing
//
//  Created by xunan on 2017/3/14.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XN3DTouch.h"

@implementation AppDelegate (XN3DTouch)

+ (BOOL)touch_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建应用图标上的3D touch快捷选项
    [self creatShortcutItem];
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if (shortcutItem) {
        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if ([shortcutItem.type isEqualToString:@"com.aist.share"]) {
            //进入分享页面
            NSLog(@"新启动APP-- 分享");
        }
        
        return NO;
    }
    
    return YES;
}


//创建应用图标上的3D touch快捷选项
+ (void)creatShortcutItem {
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.aist.XNLiNing" localizedTitle:@"分享店长" localizedSubtitle:nil icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}


+ (void)touch_application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (shortcutItem) {
        //判断设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if ([shortcutItem.type isEqualToString:@"com.aist.share"]) {
            //进入分享页面
            NSLog(@"APP没被杀死-- 分享");
        }
    }
    
    if([shortcutItem.type isEqualToString:@"com.aist.XNLiNing"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:vc animated:YES completion:^{
        }];
    }
    
    
    if (completionHandler) {
        completionHandler(YES);
    }
}


@end
