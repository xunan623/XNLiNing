//
//  XNRCDataManager.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNRCDataManager.h"
#import <RongIMLib/RongIMLib.h>
#import "RCUserInfo+XNAddition.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>
#import "XNTabbarController.h"
#import "XNRCIMBaseReq.h"
#import "XNMessageListController.h"

@implementation XNRCDataManager {
    NSMutableArray *dataSource;
}

- (instancetype)init
{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
    }
    return self;
}

+ (XNRCDataManager *)shareManager {
    static XNRCDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)getTokenAndLoginRCIM:(ConnectBlock)connectBlock {
    _connectBlock = connectBlock;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:RCIM_TOKEN];
    if (token.length) {
        // 2.登录融云
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[XNUserDefaults new].userName
                                                              name:[XNUserDefaults new].userName
                                                          portrait:@"https://www.baidu.com/img/baidu_jgylogo3.gif"
                                                                QQ:@"1246334518"
                                                               sex:@"男"];
        [[XNRCDataManager shareManager] loginRongCloudWithUserInfo:myselfInfo withToken:token];
    } else {
        // 1.获取token
        [self getUserRCTokenWithBlock:^(BOOL getTokenResult) {
            if (getTokenResult) {
                RCUserInfo *newMySelfInfo = [[RCUserInfo alloc]initWithUserId:[XNUserDefaults new].userName
                                                                      name:[XNUserDefaults new].userName
                                                                  portrait:@"https://www.baidu.com/img/baidu_jgylogo3.gif"
                                                                        QQ:@"1246334518"
                                                                       sex:@"男"];

                NSString *newToken = [[NSUserDefaults standardUserDefaults] objectForKey:RCIM_TOKEN];
                // 2.登录融云
                [[XNRCDataManager shareManager] loginRongCloudWithUserInfo:newMySelfInfo withToken:newToken];
            } else {
                XNLog(@"获取token失败");
            }
        }];
    }
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    XNLog(@"获取用户模型 : %@", userId);
    
    if (!userId.length) {
        completion(nil);
        return;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId
                                                              name:[RCIM sharedRCIM].currentUserInfo.name
                                                          portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri
                                                                QQ:[RCIM sharedRCIM].currentUserInfo.QQ
                                                               sex:[RCIM sharedRCIM].currentUserInfo.sex];
        completion(myselfInfo);
    }
    completion(nil);
}



- (void)getUserRCTokenWithBlock:(void (^)(BOOL getTokenResult))completion {
    
    NSDictionary *params = @{@"userId"      : [XNUserDefaults new].userName.length ? [XNUserDefaults new].userName : @"",
                             @"name"        : [XNUserDefaults new].userName.length ? [XNUserDefaults new].userName : @"",
                             @"portraitUri" : @"https://www.baidu.com/img/baidu_jgylogo3.gif"
                            };
    [XNRCIMBaseReq requestGetWithUrl:RCIM_GET_TOKEN params:params
                                type:XNReqeustTypePost
                     responseSucceed:^(NSDictionary *res) {
         XNLog(@"%@--", res);
         NSString *token = res[@"token"];
         if (token.length) {
             [[NSUserDefaults standardUserDefaults]  setObject:token forKey:RCIM_TOKEN];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         completion(token.length);

    } responseFailed:^(NSString *error) {
        XNLog(@"%@--", error);
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:RCIM_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completion(NO);
    }];
}

-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
        XNLog(@"登陆成功。当前登录的用户ID %@",userId);
        
        [[RCIMClient sharedRCIMClient] setCurrentUserInfo:userInfo];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_connectBlock) {
                [[RCIM sharedRCIM] setUserInfoDataSource:self];
                _connectBlock(YES);
            }
        });
    } error:^(RCConnectErrorCode status) {
        XNLog(@"登陆的错误码为:%zd", status);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_connectBlock) _connectBlock(NO);
            
        });
    } tokenIncorrect:^{
        XNLog(@"token错误");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_connectBlock) _connectBlock(NO);
        });
    }];
}

- (void)refreshBadgeValue {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        long long unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        if ([window.rootViewController isKindOfClass:[XNTabbarController class]]) {
            XNTabbarController *tabBar = (XNTabbarController *)window.rootViewController;
            XNMessageListController *chatListVC = tabBar.viewControllers[1];
            if (unreadMsgCount > 0) {
                if (unreadMsgCount > 99) {
                    chatListVC.tabBarItem.badgeValue = @"99+";
                } else {
                    [chatListVC.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%li",(long)unreadMsgCount]];
                }
            } else {
                [chatListVC.tabBarItem setBadgeValue:nil];
                
            }
        }
    });
 
}








@end
