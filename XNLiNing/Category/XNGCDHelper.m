//
//  XNGCDHelper.m
//  XNToolDemo
//
//  Created by xunan on 2016/12/30.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "XNGCDHelper.h"


#pragma mark - GCDGroup

@interface GCDGroup()

@property (strong, nonatomic, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation GCDGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}

- (void)enter {
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end



#pragma mark - GCDQueue

@interface GCDQueue()

@end
