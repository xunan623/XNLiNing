//
//  NSArray+Safe.m
//  Agency
//
//  Created by MacAir on 2018/1/25.
//  Copyright © 2018年 centanet. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


#import "NSArray+Safe.h"
#import <objc/runtime.h>


#import "NSObject+ImpChangeTool.h"
@implementation NSArray (Safe)
+ (void)load{
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSArrayI" toSafeMethodString:@"st_objectAtIndex:" targetClassString:NSStringFromClass(self)];
        
         [self SwizzlingMethod:@"initWithObjects:count:" systemClassString:@"__NSPlaceholderArray" toSafeMethodString:@"initWithObjects_st:count:" targetClassString:NSStringFromClass(self)];
        [self SwizzlingMethod:@"arrayByAddingObject:" systemClassString:@"__NSArrayI" toSafeMethodString:@"arrayByAddingObject_st:" targetClassString:NSStringFromClass(self)];
        
         [self SwizzlingMethod:@"objectAtIndexedSubscript:" systemClassString:@"__NSArrayI" toSafeMethodString:@"st_objectAtIndexedSubscript:" targetClassString:NSStringFromClass(self)];
        
         [self SwizzlingMethod:@"lastObject" systemClassString:@"__NSArrayI" toSafeMethodString:@"st_lastObject" targetClassString:NSStringFromClass(self)];
         [self SwizzlingMethod:@"firstObject" systemClassString:@"__NSArrayI" toSafeMethodString:@"st_firstObject" targetClassString:NSStringFromClass(self)];        
    });
}

-(id)st_lastObject{
    if(self.count>0){
        return [self st_lastObject];
    }else{
        return nil;
    }
    
}
-(id)st_firstObject{
    if(self.count>0){
        return [self st_firstObject];
    }else{
        return nil;
    }
}
-(id)st_objectAtIndexedSubscript:(NSUInteger)idx{
    if (idx >= [self count]) {
        return nil;
    }
    return [self st_objectAtIndexedSubscript:idx];
}

- (id)st_objectAtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self st_objectAtIndex:index];
}
- (NSArray *)arrayByAddingObject_st:(id)anObject {
    if (!anObject) {
        return self;
    }
    return [self arrayByAddingObject_st:anObject];
}
- (instancetype)initWithObjects_st:(id *)objects count:(NSUInteger)count {
    NSUInteger newCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!objects[i]) {
            break;
        }
        newCount++;
    }
    self = [self initWithObjects_st:objects count:newCount];
    return self;
}


@end

#pragma clang diagnostic pop
