//
//  XNMessageListCell.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNMessageListCell.h"

@implementation XNMessageListCell

+ (instancetype)msGetInstance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0] lastObject];
}


@end
