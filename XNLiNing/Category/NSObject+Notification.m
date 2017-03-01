//
//  NSObject+Notification.m
//  RWKit
//
//  Created by Ranger on 16/5/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSObject+Notification.h"
@import ObjectiveC.runtime;

@interface RWNotificationHelper : NSObject {
    @package
    id              _notiTarget;        //!< 处理通知那个类的实例 用来调用接受通知后的方法
    id              _postNotiObject;    //!< 通知的来源 即谁发的通知 为nil时接受所有的通知
    SEL             _notiSelector;      //!< 接受到通知后调用的方法
    NSString        *_notiName;         //!< 通知的名字
    NSDictionary    *_userInfo;         //!< 通知传递的参数NSNotification的属性 类型为字典

    void(^_block)(NSNotification *noti);  //!< 传递参数的回调
}

@end

@implementation RWNotificationHelper

- (instancetype)initWithName:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(id)anObject {
    if (self = [super init]) {
        _notiTarget = target;
        _notiSelector = aSelector;
        _notiName = aName;
        _postNotiObject = anObject;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:aName
                                                   object:anObject];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)aName object:(id)anObject block:(void(^)(NSNotification *noti))block {
    if (self = [super init]) {
        _notiName = aName;
        _postNotiObject = anObject;
        _block  = block;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:aName
                                                   object:anObject];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)handleNotification:(NSNotification *)notification {
    if (_block)
        _block(notification);
    
    if ([_notiTarget respondsToSelector:_notiSelector])
        [_notiTarget performSelector:_notiSelector withObject:notification];
}

#pragma clang diagnostic pop

@end


#pragma mark-  core part

static const void *Notification_Container = &Notification_Container;

@interface NSObject (NotificationPrivate)

@property (nonatomic, strong) NSMutableDictionary *notiContainer;

@end

@implementation NSObject (Notification)

- (NSMutableDictionary *)notiContainer {
    return objc_getAssociatedObject(self, Notification_Container) ?: ({
        NSMutableDictionary *dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, Notification_Container, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dict;
    });
}

#pragma mark-  add observer of a notification

- (void)rw_observeNotification:(NSString *)aName block:(void(^)(NSNotification *noti))block {
    [self rw_observeNotification:aName object:nil block:block];
}

- (void)rw_observeNotification:(NSString *)aName object:(id)anObject block:(void(^)(NSNotification *noti))block {
    NSAssert(block, @"block 不能为nil");
    NSAssert(aName.length > 0, @"NotificationName 不能为@\"\"");
    
    RWNotificationHelper *notification = [[RWNotificationHelper alloc] initWithName:aName
                                                                               object:anObject
                                                                                block:block];
    NSString *key = [NSString stringWithFormat:@"%@", aName];
    self.notiContainer[key] = notification;
}

- (void)rw_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector {
    
    [self rw_observeNotification:aName target:target selector:aSelector object:nil];
}

- (void)rw_observeNotification:(NSString *)aName target:(id)target selector:(SEL)aSelector object:(id)anObject {
    NSAssert([target respondsToSelector:aSelector], @"selector & target 必须存在");
    NSAssert(aName.length > 0, @"NotificationName 不能为@\"\"");
    
    RWNotificationHelper *notification = [[RWNotificationHelper alloc] initWithName:aName
                                                                             target:target
                                                                           selector:aSelector
                                                                             object:anObject];
    
    NSString *key = [NSString stringWithFormat:@"%@", aName];
    self.notiContainer[key] = notification;
}

#pragma mark-  post notification

- (void)rw_postNotification:(NSString *)aName {
    [self rw_postNotification:aName object:nil userInfo:nil];
}

- (void)rw_postNotification:(NSString *)aName object:(id)anObject {
    [self rw_postNotification:aName object:anObject userInfo:nil];
}

- (void)rw_postNotification:(NSString *)aName userInfo:(NSDictionary *)aUserInfo {
    [self rw_postNotification:aName object:nil userInfo:aUserInfo];
}

- (void)rw_postNotification:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
    });
}

#pragma mark- remove notification

- (void)rw_removeNotification:(NSString *)aName {
    if (!aName || !aName.length) {
        [self rw_removeAllNotification];
        return;
    }
    [self.notiContainer removeObjectForKey:aName];
}

- (void)rw_removeAllNotification {
    [self.notiContainer removeAllObjects];
}

@end
