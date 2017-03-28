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
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>


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
        
        [weakSelf getRCIMChatList];
        [[XNRCDataManager shareManager] refreshBadgeValue];
        
    });
}

- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
    return YES;
}

/**
 * APP处于后台
 */
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {
    
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        NSString * userMessage = [NSString stringWithFormat:@"%@:%@",senderName,textMessage.content];
    
        [XNMessageListController registerLocalNotification:0.01 Message:userMessage sendUserId:message.targetId];
    } else if ([message.content isMemberOfClass:[RCImageMessage class]]) {
        RCImageMessage *textMessage = (RCImageMessage *)message.content;
        NSString * imgMessage = [NSString stringWithFormat:@"%@:%@",senderName,textMessage.imageUrl];
        [XNMessageListController registerLocalNotification:0.01 Message:imgMessage sendUserId:message.targetId];
    } else {
        
    }
    return YES;
}
// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime Message:(NSString *)message sendUserId:(NSString *)sendUserId{
    
    static NSInteger index = 1;
    UILocalNotification *localNotifi = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    localNotifi.fireDate = fireDate;
    // 时区
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    localNotifi.repeatInterval = kCFCalendarUnitEra;
    localNotifi.repeatInterval = 0;
    
    // 通知内容
    localNotifi.alertBody =  message;
    localNotifi.applicationIconBadgeNumber = index;
    index ++;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:sendUserId forKey:@"rc_id"];
    NSDictionary *sumUserDict = [NSDictionary dictionaryWithObject:userDict forKey:@"rc_content"];
    localNotifi.userInfo = sumUserDict;
    
    if (MODEL_VERSION >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else if (MODEL_VERSION >= 8.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    AudioServicesPlaySystemSound(1007);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}

+ (void)registerLocalNotification:(NSInteger)alertTime Message:(NSString *)message {
    
    static NSInteger index = 1;
    UILocalNotification *localNotifi = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    localNotifi.fireDate = fireDate;
    // 时区
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    localNotifi.repeatInterval = kCFCalendarUnitEra;
    localNotifi.repeatInterval = 0;
    
    // 通知内容
    localNotifi.alertBody =  message;
    localNotifi.applicationIconBadgeNumber = index;
    index ++;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:[XNUserDefaults new].userName forKey:@"rc_id"];
    NSDictionary *sumUserDict = [NSDictionary dictionaryWithObject:userDict forKey:@"rc_content"];
    localNotifi.userInfo = sumUserDict;
    
    if (MODEL_VERSION >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else if (MODEL_VERSION >= 8.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    AudioServicesPlaySystemSound(1007);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}

@end
