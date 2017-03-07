//
//  RWUserDefaults.m
//  Test05111544
//
//  Created by Ranger on 16/5/17.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWUserDefaults.h"
#import "CocoaCracker.h"
@import UIKit;

#define Make_Setter_Method(type, setStatement)  \
method_setImplementation(setter, imp_implementationWithBlock(^(id self, type param) {  \
[userDefault setStatement:param forKey:key];   \
[userDefault synchronize];\
}))

#define Make_Getter_Method(type, getStatement)  \
method_setImplementation(getter, imp_implementationWithBlock(^(id self) {  \
type returnParam = [userDefault getStatement:key];  \
return returnParam;    \
}))

#define OverrideSetterGetterMethod(type, setStatement, getStatement)   \
Make_Setter_Method(type, setStatement);    \
Make_Getter_Method(type, getStatement)


NS_INLINE void rwud_typeEncodings(NSUserDefaults *userDefault, Class cls, const char *name, const char *attribute) {

    char *ch_setter;
    asprintf(&ch_setter, "set%c%s:", toupper(name[0]), name + 1);
    SEL setterSel = sel_registerName(ch_setter);
    Method setter = class_getInstanceMethod(cls, setterSel);
    
    SEL getterSel = sel_registerName(name);
    Method getter = class_getInstanceMethod(cls, getterSel);
    free(ch_setter);
    
    NSString *key = NSStringFromSelector(method_getName(getter));
    switch (attribute[0]) {
        case 's':  // short
        case 'i':  // int
        case 'l':  // long
        case 'q':  // long long
        case 'C':  // unsigned char
        case 'S':  // unsigned short
        case 'I':  // unsigned int
        case 'L':  // unsigned long
        case 'Q':  // unsigned long long
        {
            OverrideSetterGetterMethod(NSInteger, setInteger, integerForKey);
            break;
        }
            
        case 'B':  // BOOL
        case 'c':  // char
        {
            OverrideSetterGetterMethod(NSInteger, setBool, boolForKey);
            break;
        }
            
        case 'f':  // float
        {
            OverrideSetterGetterMethod(float, setFloat, floatForKey);
            break;
        }
            
        case 'd':  // double
        {
            OverrideSetterGetterMethod(double, setDouble, floatForKey);
            break;
        }
            
        case '@':  // object
        {
            if (strstr(attribute, class_getName([NSString class])) != NULL
                || strstr(attribute, class_getName([NSMutableString class])) != NULL) {
                OverrideSetterGetterMethod(NSString *, setObject, objectForKey);
            }
            else if (strstr(attribute, class_getName([NSNumber class])) != NULL) {
                OverrideSetterGetterMethod(NSNumber *, setObject, objectForKey);
            }
            else if (strstr(attribute, class_getName([NSArray class])) != NULL
                     || strstr(attribute, class_getName([NSMutableArray class])) != NULL) {
                OverrideSetterGetterMethod(NSArray *, setObject, arrayForKey);
            }
            else if (strstr(attribute, class_getName([NSDictionary class])) != NULL
                     || strstr(attribute, class_getName([NSMutableDictionary class])) != NULL) {
                OverrideSetterGetterMethod(NSDictionary *, setObject, dictionaryForKey);
            }
            else if (strstr(attribute, class_getName([NSData class])) != NULL) {
                OverrideSetterGetterMethod(NSData *, setObject, dataForKey);
            }
            else if (strstr(attribute, class_getName([NSURL class])) != NULL) {
                OverrideSetterGetterMethod(NSNumber *, setObject, objectForKey);
            }
            else if (strstr(attribute, class_getName([NSDate class])) != NULL) {
                OverrideSetterGetterMethod(NSDate *, setObject, objectForKey);
            }

            break;
        }
        default: break;
    }
};

@interface RWUserDefaults () {
    NSUserDefaults  *_userDefault;
    Class _registeredClass;
}

@end

@implementation RWUserDefaults

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark-   public methods

- (void)registerClass:(Class)aClass {
    _registeredClass = aClass;
    [[CocoaCracker handle:aClass] copyPropertyList:^(objc_property_t  _Nonnull property) {
        const char *name = property_getName(property);
        const char *attributes = property_copyAttributeValue(property, "T");
        rwud_typeEncodings(_userDefault, aClass, name, attributes);
    }];
}

- (void)unregisterClass {
    _registeredClass = nil;
}

@end
