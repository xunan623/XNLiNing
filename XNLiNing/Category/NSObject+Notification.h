//
//  NSObject+Notification.h
//  RWKit
//
//  Created by Ranger on 16/5/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Notification)

/** 建立通知监听者 默认anObject为空 */
- (void)rw_observeNotification:(NSString *)aName block:(void(^)(NSNotification *noti))block;
/** 建立通知监听者 */
- (void)rw_observeNotification:(NSString *)aName object:(nullable id)anObject block:(void(^)(NSNotification *noti))block;
/** 建立通知监听者 默认anObject 为空 */
- (void)rw_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector;
/** 建立通知监听者 */
- (void)rw_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(nullable id)anObject;

/** 发送通知 默认anObject, aUserInfo 为nil */
- (void)rw_postNotification:(NSString *)aName;
/** 发送通知 默认aUserInfo 为nil */
- (void)rw_postNotification:(NSString *)aName object:(nullable id)anObject;
/** 发送通知 默认anObject为nil*/
- (void)rw_postNotification:(NSString *)aName userInfo:(nullable NSDictionary *)aUserInfo;
/** 发送通知 */
- (void)rw_postNotification:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

/** 移除不要监听的通知 */
- (void)rw_removeNotification:(nullable NSString *)aName;
/** 移除全部通知 */
- (void)rw_removeAllNotification;

@end

NS_ASSUME_NONNULL_END