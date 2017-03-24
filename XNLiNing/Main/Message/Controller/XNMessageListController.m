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

@interface XNMessageListController ()<UITableViewDelegate, UITableViewDataSource, RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *listArray;

@property (strong, nonatomic) RCIM *rcimMessage;
@property (strong, nonatomic) RCIMClient *rcimClientMessage;


@end

@implementation XNMessageListController

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
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
        [_rcimClientMessage setRCConnectionStatusChangeDelegate:self];
    }
    return _rcimClientMessage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self getRCIMChatList];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[XNRCDataManager shareManager] refreshBadgeValue];
}

- (void)setupUI {
    XNBaseNavigationBar * navBar = [[XNBaseNavigationBar alloc] init];
    navBar.titleLabel.text = @"消息列表";
    [self.view addSubview:navBar];
    self.conversationListTableView.frame = CGRectMake(0, 44, XNScreen_Width, XNScreen_Height - 44);

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNMessageListCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([XNMessageListCell class])];
    
}

- (void)getRCIMChatList {
    [self.listArray removeAllObjects];
    
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

#pragma mark - TabeleViewDelegate


@end
