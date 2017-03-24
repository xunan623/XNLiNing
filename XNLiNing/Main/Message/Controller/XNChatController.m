//
//  XNChatController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNChatController.h"
#import "XNBaseNavigationBar.h"

@interface XNChatController ()

@end

@implementation XNChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    XNBaseNavigationBar * navBar = [[XNBaseNavigationBar alloc] init];
    navBar.titleLabel.text = self.targetId;
    navBar.backButton.hidden = NO;
    [self.view addSubview:navBar];
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, XNScreen_Width, XNScreen_Height - 64);
}


@end
