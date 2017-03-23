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
#import "XNRCIMBaseReq.h"

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
    
    NSDictionary *params = @{@"userId"      : [XNUserDefaults new].userName,
                             @"name"        : [XNUserDefaults new].userName,
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

        [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:RCIM_IS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } error:^(RCConnectErrorCode status) {
        XNLog(@"登陆的错误码为:%zd", status);
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:RCIM_IS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } tokenIncorrect:^{
        XNLog(@"token错误");
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:RCIM_IS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}









@end
