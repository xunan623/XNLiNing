//
//  XNSaveUserDefault.h
//  XNLiNing
//
//  Created by xunan on 2017/3/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNLoginModel.h"

@interface XNSaveUserDefault : NSObject

+ (instancetype)saveUserDefaultWith:(XNLoginContent *)content;

@end
