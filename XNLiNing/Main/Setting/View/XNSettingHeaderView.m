//
//  XNSettingHeaderView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/7.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingHeaderView.h"

@interface XNSettingHeaderView()


@end

@implementation XNSettingHeaderView

+ (instancetype)msGetInstance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rw_width = XNScreen_Width;
    self.rw_height = 200;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rw_width = XNScreen_Width;
    self.rw_height = 200;
}

@end
