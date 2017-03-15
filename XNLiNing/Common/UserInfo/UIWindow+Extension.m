//
//  UIWindow+Extension.m
//  XNLiNing
//
//  Created by xunan on 2017/3/7.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "XNTabbarController.h"
#import "XNLoginController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController {
    self.rootViewController = [[XNLoginController alloc] init];
    return;
    NSString *key = @"CFBundleVersion";
    //存储在沙盒中得版本号(上一次的使用版本)
    NSString *lastVersion =  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //当前软件的版本号
    NSString *currentVersion =  [NSBundle mainBundle].infoDictionary[key];
    
    XNUserDefaults *ud = [XNUserDefaults new];
    if (ud.userName.length && ud.userPassword.length) { // 登录过
        if ([currentVersion isEqualToString:lastVersion]) {//版本号相同:这次打开和上次打开的版本相同
            self.rootViewController = [[XNTabbarController alloc] init];
        }else {
            self.rootViewController = [[XNLoginController alloc] init];
            //将当前的版本号存入沙盒
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        self.rootViewController = [[XNLoginController alloc] init];
    }
    
}

- (void)saveVersionToNSUserDefault {
    NSString *key = @"CFBundleVersion";
    //当前软件的版本号
    NSString *currentVersion =  [NSBundle mainBundle].infoDictionary[key];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
