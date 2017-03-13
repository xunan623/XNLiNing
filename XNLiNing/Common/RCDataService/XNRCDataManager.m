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
    XNLog(@"getUserInfoWithUserId : %@", userId);
    
    if (!userId || userId.length == 0) {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        completion(nil);
        return;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri QQ:[RCIM sharedRCIM].currentUserInfo.QQ sex:[RCIM sharedRCIM].currentUserInfo.sex];
        completion(myselfInfo);
        
    }
    
    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].friendsArray.count; i++) {
        RCUserInfo *aUser = [AppDelegate shareAppDelegate].friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            completion(aUser);
            break;
        }
    }
}

- (void)syncFriendList:(void(^)(NSMutableArray * friends,BOOL isSuccess))completion {
    dataSource = [NSMutableArray array];
    for (NSInteger i = 1; i<7; i++) {
        if(i==1){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"文明" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151210/1449727866527.jpg" QQ:@"740747055" sex:@"男"];
            [dataSource addObject:aUserInfo];
        }else if (i==2) {
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"张全蛋" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151210/1449727755947.jpg" QQ:@"张全蛋的QQ信息" sex:@"男"];
            [dataSource addObject:aUserInfo];
        }
    }
    
    [AppDelegate shareAppDelegate].friendsArray = dataSource;
    completion(dataSource,YES);
}


-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
        NSLog(@"login success with userId %@",userId);
        //同步好友列表
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            XNLog(@"%@",friends);
            if (isSuccess) {
            }
        }];
        [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
        
    } error:^(RCConnectErrorCode status) {
        XNLog(@"status = %ld",(long)status);
    } tokenIncorrect:^{
        NSLog(@"token 错误");
    }];
    
    
    
    
}















@end
