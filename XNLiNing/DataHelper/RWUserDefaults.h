//
//  RWUserDefaults.h
//  Test05111544
//
//  Created by Ranger on 16/5/17.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWUserDefaults : NSObject

+ (instancetype)shareInstance;

- (void)registerClass:(Class)aClass;
- (void)unregisterClass;

//- (void)unregisterClass:(Class)aClass;
//- (void)removeObjectForKey:(NSString *)key;
//- (void)removeObjectsForKeys:(NSArray *)keys;
//- (void)cleanUserdefaults;

@end
