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

@interface XNMessageListController ()<UITableViewDelegate, UITableViewDataSource, RCIMReceiveMessageDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *chatListArray;

@property (strong, nonatomic) RCIMClient *rcimClientMessage;


@end

@implementation XNMessageListController

-(instancetype)init {
    if (self = [super init]) {
        [self.rcimMessage setReceiveMessageDelegate:self];
    }
    return self;
}

- (NSMutableArray *)chatListArray {
    if (!_chatListArray) {
        _chatListArray = [NSMutableArray array];
    }
    return _chatListArray;
}

- (RCIM *)rcimMessage {
    if (!_rcimMessage) {
        _rcimMessage = [RCIM sharedRCIM];
        [_rcimMessage setReceiveMessageDelegate:self];

    }
    return _rcimMessage;
}

- (RCIMClient *)rcimClientMessage {
    if (!_rcimClientMessage) {
        _rcimClientMessage = [RCIMClient sharedRCIMClient];
    }
    return _rcimClientMessage;
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
    XNBaseNavigationBar * navBar = [[XNBaseNavigationBar alloc] init];
    navBar.titleLabel.text = @"消息列表";
    [self.view addSubview:navBar];

    self.tableView.rowHeight = 68;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNMessageListCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([XNMessageListCell class])];
    
}

- (void)getRCIMChatList {
    [self.chatListArray removeAllObjects];
    
    NSMutableArray *allChatConversion = [[NSMutableArray alloc]initWithArray:[self.rcimClientMessage getConversationList:@[@(ConversationType_PRIVATE)]]];
    [self.chatListArray addObjectsFromArray:allChatConversion];
    [self.tableView reloadData];
    
}

#pragma mark - RCIMReceiveMessageDelegate

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf getRCIMChatList];
        [[XNRCDataManager shareManager] refreshBadgeValue];
        
    });
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
    conversationVC.title = model.objectName;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


@end
