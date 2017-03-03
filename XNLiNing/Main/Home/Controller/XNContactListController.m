

//
//  XNContactListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNContactListController.h"
#import "XNSecondController.h"

@interface XNContactListController ()

@end

@implementation XNContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnClick {
    
    XNSecondController *secondVC = [[XNSecondController alloc] init];
    secondVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
