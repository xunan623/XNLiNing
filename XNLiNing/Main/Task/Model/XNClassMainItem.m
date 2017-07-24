//
//  XNClassMainItem.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNClassMainItem.h"
#import <MJExtension.h>

@implementation XNClassMainItem

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"goods" : @"XNClassSubItem"
             };
}

@end
