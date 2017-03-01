//
//  CocoaCracker.m
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "CocoaCracker.h"

@interface CocoaCracker () {
    Class _targetCls;
}

@end

@implementation CocoaCracker

+ (instancetype)handle:(Class)cls {
    return [[self alloc] initWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        
        _targetCls = cls;
    }
    return self;
}

#pragma mark-  copy property list

- (void)copyPropertyName:(void(^)(NSString *pName))block {
    NSParameterAssert(block);

    [self copyPropertyInfo:^(NSString *pName, NSString *pType) {
        block(pName);
    } copyAttriEntirely:NO];
}


- (void)copyPropertyType:(void(^)(NSString *pType))block {
    NSParameterAssert(block);

    [self copyPropertyInfo:^(NSString *pName, NSString *pType) {
        block(pType);
    } copyAttriEntirely:NO];
}

- (void)copyPropertyTypeEntirely:(void(^)(NSString *pTypeEntirely))block {
    NSParameterAssert(block);
    [self copyPropertyInfo:^(NSString *pName, NSString *pTypeEntirely) {
        block(pTypeEntirely);
    } copyAttriEntirely:YES];
}

- (void)copyPropertyInfo:(void(^)(NSString *pName, NSString *pTypeEntirely))block
            copyAttriEntirely:(BOOL)isCopy {
    NSParameterAssert(block);
    [self copyPropertyList:^(objc_property_t property) {
        NSString *pName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *pType;
        if (isCopy)
            pType = [NSString stringWithUTF8String:property_getAttributes(property)];
        else
            pType = [NSString stringWithUTF8String:property_copyAttributeValue(property, "T")];
        
        block(pName, pType);
    }];
}

- (void)copyPropertyList:(void(^)(objc_property_t property))block {
    NSParameterAssert(block);
    u_int count;
    objc_property_t *properties = class_copyPropertyList(_targetCls, &count);
    for (u_int i = 0; i < count; i++) {
        block(properties[i]);
    }
    
    free(properties);
}

#pragma mark-  swizzle methods

- (BOOL)swizzleMethod:(SEL)oldSelector withMethod:(SEL)newSelector {
    
    Method oldMethod = class_getInstanceMethod(_targetCls, oldSelector);
    Method newMethod = class_getInstanceMethod(_targetCls, newSelector);
    
    BOOL didAddMethod = class_addMethod(_targetCls,
                                        oldSelector,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(_targetCls,
                            newSelector,
                            method_getImplementation(oldMethod),
                            method_getTypeEncoding(oldMethod));
    }
    else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
    return didAddMethod;
}

#pragma mark-  copy method list
- (void)copyMethodName:(void (^)(NSString *selectorName))block {
    NSParameterAssert(block);

    [self copyMethodList:^(SEL aSelector) {
        block(NSStringFromSelector(aSelector));
    }];
}

- (void)copyMethodList:(void (^)(SEL aSelector))block {
    NSParameterAssert(block);
    u_int count;
    Method *methods = class_copyMethodList(_targetCls, &count);
    for (int i = 0; i < count ; i++) {
        SEL aSelector = method_getName(methods[i]);
        block(aSelector);
    }
    free(methods);
}

@end
