//
//  XNLoginModel.m
//  XNLiNing
//
//  Created by xunan on 2017/3/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLoginModel.h"

@implementation XNLoginContent

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"id": @"userId"
                                                                  }];
}

@end

@implementation XNLoginModel

@end
