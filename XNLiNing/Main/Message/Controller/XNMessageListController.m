//
//  XNMessageListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNMessageListController.h"
#import "XNMessageListCell.h"
#import "XNBaseNavigationBar.h"
#import "XNChatController.h"

@interface XNMessageListController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XNMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
}

- (void)setupUI {
    XNBaseNavigationBar * navBar = [[XNBaseNavigationBar alloc] init];
    navBar.titleLabel.text = @"消息列表";
    [self.view addSubview:navBar];
    self.conversationListTableView.frame = CGRectMake(0, 44, XNScreen_Width, XNScreen_Height - 44);
 
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    item.badgeValue= @"2";
}


//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    XNChatController *conversationVC = [[XNChatController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.objectName;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


@end
