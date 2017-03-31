//
//  XNProfileController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/31.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNProfileController.h"

@interface XNProfileController ()

@end

@implementation XNProfileController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBar.titleLabel.text = @"设置";
    self.navBar.backButton.hidden = NO;
}

@end
