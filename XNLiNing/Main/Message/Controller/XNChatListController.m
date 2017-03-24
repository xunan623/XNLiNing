//
//  XNChatListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNChatListController.h"
#import "XNChatController.h"
#import "XNBaseNavigationBar.h"


@interface XNChatListController ()

@end

@implementation XNChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    XNBaseNavigationBar * navBar = [[XNBaseNavigationBar alloc] init];
    navBar.titleLabel.text = @"消息列表";
    [self.view addSubview:navBar];
    self.conversationListTableView.frame = CGRectMake(0, 44, XNScreen_Width, XNScreen_Height - 44);

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
