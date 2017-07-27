//
//  XNShopCartModel.m
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopCartModel.h"
#import "XNShopViewModel.h"
#import "XNCommodityModel.h"

@implementation XNShopCartModel

- (void)setVm:(XNShopViewModel *)vm {
    _vm = vm;
//    [self addObserver:vm forKeyPath:@"isSelect" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (void)dealloc {
//    [self removeObserver:_vm forKeyPath:@"isSelect"];
}

@end
