//
//  XNContactCell.m
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNContactCell.h"

@interface XNContactCell()


@end

@implementation XNContactCell

+ (instancetype)msGetInstance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:0] lastObject];
}


@end
