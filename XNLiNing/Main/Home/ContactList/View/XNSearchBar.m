//
//  XNSearchBar.m
//  XNLiNing
//
//  Created by xunan on 2017/3/15.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSearchBar.h"

@implementation XNSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = XNAPPNormalBGColor;
    self.placeholder = @"按用户名搜索";
    self.keyboardType = UIKeyboardTypeDefault;
    self.showsCancelButton = NO;
    [self setBackgroundImage:[[UIImage alloc] init]];
    self.tintColor = XNAPPASSISTColor;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];

}

@end
