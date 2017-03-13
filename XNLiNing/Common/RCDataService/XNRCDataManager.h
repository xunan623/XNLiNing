//
//  XNRCDataManager.h
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

/**
 * 大神提供的管理融云逻辑的类
 */

@interface XNRCDataManager : NSObject<RCIMUserInfoDataSource, RCIMGroupInfoDataSource>

+ (XNRCDataManager *)shareManager;

/**
 * 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;


/**
 * 从服务器同步好友列表
 */
- (void)syncFriendList:(void(^)(NSMutableArray * friends,BOOL isSuccess))completion;

/**
 *  登录融云服务器（connect，用token去连接）
 *
 *  @param userInfo 用户信息
 *  @param token    token令牌
 */
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token;



@end
