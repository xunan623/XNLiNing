//
//  XNBasePresenter.m
//  XNLiNing
//
//  Created by Dandre on 2018/3/6.
//  Copyright © 2018年 xunan. All rights reserved.
//

#import "XNBasePresenter.h"

@implementation XNBasePresenter

- (instancetype)initWithView:(id)view{
    
    if (self = [super init]) {
        self.presentV = view;
    }
    return self;
}

@end
