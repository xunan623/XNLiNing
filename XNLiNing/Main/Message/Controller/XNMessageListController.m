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
#import "XNMessageListCell.h"
#import <RongIMLib/RongIMLib.h>
#import "AppDelegate+XNRongIMKit.h"



@interface XNMessageListController ()<UITableViewDelegate, UITableViewDataSource, RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *chatListArray;

@end

@implementation XNMessageListController

- (NSMutableArray *)chatListArray {
    if (!_chatListArray) {
        _chatListArray = [NSMutableArray array];
    }
    return _chatListArray;
}

- (XNBaseNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[XNBaseNavigationBar alloc] init];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getRCIMChatList];
    
    [[XNRCDataManager shareManager] refreshBadgeValue];
}

- (void)setupUI {
    self.navBar.titleLabel.text = @"消息列表";

    self.tableView.rowHeight = 68;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNMessageListCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([XNMessageListCell class])];
    
}

- (void)initData {
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

- (void)getRCIMChatList {
    [self.chatListArray removeAllObjects];
    
    NSMutableArray *allChatConversion = [[NSMutableArray alloc]initWithArray:[[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]]];
    [self.chatListArray addObjectsFromArray:allChatConversion];
    [self.tableView reloadData];
    
}



#pragma mark - TabeleViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" withRowCount:self.chatListArray.count];
    return self.chatListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XNMessageListCell *cell = [XNMessageListCell msGetInstance];
    cell.model = self.chatListArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RCConversationModel *deleteConversation = [self.chatListArray objectAtIndex:indexPath.row];
    BOOL isDeleteSuccess = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                                                    targetId:deleteConversation.targetId];
    BOOL isClearMsgSuccess = [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE
                                                                 targetId:deleteConversation.targetId];
    if (isClearMsgSuccess && isDeleteSuccess) {
        [self getRCIMChatList];
        [[XNRCDataManager shareManager] refreshBadgeValue];
    } else {
        return;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RCConversationModel *model = self.chatListArray[indexPath.row];
    XNChatController *conversationVC = [[XNChatController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.targetId;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - RCIMReceiveMessageDelegate

/**
 *  网络状态变化(目前暂时没用到)
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"您的帐号已在别的设备上登录，\n您被迫下线！"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 刷新数据 刷新未读消息数
        [weakSelf getRCIMChatList];
        [[XNRCDataManager shareManager] refreshBadgeValue];
        
        int allunread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];//获取消息数量
        // 发送本地推送
        if ([message.content isMemberOfClass:[RCTextMessage class]]) {  // 文字
            RCTextMessage *textMessage = (RCTextMessage *)message.content;
            NSString * userMessage = [NSString stringWithFormat:@"%@:%@", message.senderUserId,textMessage.content];
            
            [AppDelegate registerLocalNotification:0.1 Message:userMessage
                                        sendUserId:message.targetId
                                       unReadCount:allunread];
        } else if ([message.content isMemberOfClass:[RCImageMessage class]]) {  // 图片
            RCImageMessage *textMessage = (RCImageMessage *)message.content;
            NSString * imgMessage = [NSString stringWithFormat:@"%@:%@",message.senderUserId,textMessage.imageUrl];
            [AppDelegate registerLocalNotification:0.1 Message:imgMessage
                                        sendUserId:message.targetId
                                       unReadCount:allunread];
        } else if ([message.content isMemberOfClass:[RCLocationMessage class]]) {
            NSString * imgMessage = [NSString stringWithFormat:@"%@:%@",message.senderUserId,@"位置"];
            [AppDelegate registerLocalNotification:0.1 Message:imgMessage
                                        sendUserId:message.targetId
                                       unReadCount:allunread];
        }
        
    });
    

}


/**
 * APP处于后台 不知道为什么老是不走
 */
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {
    
    return YES;
}


@end
