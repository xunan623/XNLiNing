//
//  XNHomeGoodsController.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNHomeGoodsController.h"
#import "XNContactListController.h"

@interface XNHomeGoodsController ()

@end

@implementation XNHomeGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupBase {
    self.navBar.hidden = NO;
}

#pragma mark - 联系人列表
- (IBAction)contactListClick:(id)sender {
    XNContactListController *contactVC = [[XNContactListController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

@end
