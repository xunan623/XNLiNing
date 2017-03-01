//
//  XNGCDHelper.h
//  XNToolDemo
//
//  Created by xunan on 2016/12/30.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - GCDGroup

@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

- (instancetype)init;

- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end


#pragma mark - GCDQueue

@interface GCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;

+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHightPriorityGlobalQueue:(dispatch_block_t)block;

@end
