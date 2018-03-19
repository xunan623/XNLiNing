//
//  NSMutableDictionary+Safe.m
//  Agency
//
//  Created by MacAir on 2018/1/25.
//  Copyright © 2018年 centanet. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import <objc/runtime.h>
#import "NSObject+ImpChangeTool.h"
@implementation NSMutableDictionary (Safe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SwizzlingMethod:@"st_removeObjectForKey:" systemClassString:NSStringFromClass(self) toSafeMethodString:@"removeObjectForKey:" targetClassString:@"__NSDictionaryM"];
        [self SwizzlingMethod:@"st_setObject:forKey:" systemClassString:NSStringFromClass(self) toSafeMethodString:@"setObject:forKey:" targetClassString:@"__NSDictionaryM"];
    });
}
- (void)st_removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    [self st_removeObjectForKey:key];
}
- (void)st_setObject:(id)obj forKey:(id <NSCopying>)key {
    if (!obj) {
        return;
    }
    if (!key) {
        return;
    }
    [self st_setObject:obj forKey:key];
}
@end
