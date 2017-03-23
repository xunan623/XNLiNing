//
//  XNRCDataManager.h
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>


typedef void(^ConnectBlock)(BOOL isSuccess);

/**
 * 大神提供的管理融云逻辑的类
 */

@interface XNRCDataManager : NSObject<RCIMUserInfoDataSource>


@property (nonatomic, copy) ConnectBlock connectBlock;

+ (XNRCDataManager *)shareManager;

/**
 * 获取token并登录
 */
- (void)getTokenAndLoginRCIM:(ConnectBlock)connectBlock;

/**
 * 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;

/**
 * 从融云获取用户token信息
 */
- (void)getUserRCTokenWithBlock:(void (^)(BOOL getTokenResult))completion;

/**
 *  登录融云服务器（connect，用token去连接）
 *
 *  @param userInfo 用户信息
 *  @param token    token令牌
 */
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token;

/**
 * 刷新tabbar角标
 */
- (void)refreshBadgeValue;

@end
