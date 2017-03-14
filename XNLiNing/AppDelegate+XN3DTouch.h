//
//  AppDelegate+XN3DTouch.h
//  XNLiNing
//
//  Created by xunan on 2017/3/14.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XN3DTouch)

+ (BOOL)touch_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)touch_application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;

@end
