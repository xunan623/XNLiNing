//
//  XNChatController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNChatController.h"
#import "XNBaseNavigationBar.h"
#import "XNChatSystemMessage.h"
#import "XNSimpleMessageCell.h"

@interface XNChatController ()<RCPluginBoardViewDelegate>

@property (strong, nonatomic) XNBaseNavigationBar *navBar;

@end

@implementation XNChatController

- (XNBaseNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[XNBaseNavigationBar alloc] init];
        _navBar.backButton.hidden = NO;
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 头像类型 矩形还是圆角
        [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setupData];
    
}

- (void)setupUI {
    
    self.navBar.titleLabel.text = self.targetId;
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, XNScreen_Width, XNScreen_Height - 64);
    
    // 键盘类型
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType
                                               style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    [self.conversationMessageCollectionView registerClass:XNSimpleMessageCell.class
                               forCellWithReuseIdentifier:NSStringFromClass([XNSimpleMessageCell class])];
    
    // 拓展功能
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"icon-back"]
                                                                   title:@"发红包"
                                                                     tag:PLUGIN_BOARD_ITEM_NEED_TAG];    
}

- (void)setupData {
    NSInteger count = [[RCIMClient sharedRCIMClient] getMessageCount:ConversationType_PRIVATE
                                                            targetId:self.targetId];
    if (count == 0) { // 没有聊天就默认发送系统消息
        [self sendSystemDefaultMsg];
    } else {
        [self sendMsgwithContent:self.messageContent];
    }
}

#pragma mark - 点击事件回调

- (void)didTapCellPortrait:(NSString *)userId {
    [super didTapCellPortrait:userId];
    XNLog(@"%@", userId);
    
}


#pragma mark - 上个界面带来需要默认发送的信息

- (void)sendMsgwithContent:(NSString *)content {
    if (content.length) {
        RCTextMessage * TextMessage = [RCTextMessage messageWithContent:self.messageContent];
        [self sendMessage:TextMessage pushContent:nil];
    }
}

#pragma mark - 拓展功能回调
-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    switch (tag) {
        case PLUGIN_BOARD_ITEM_NEED_TAG: {  // 发红包
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - 发送默认系统消息

- (void)sendSystemDefaultMsg {
    XNChatSystemMessage *textMessage = [[XNChatSystemMessage alloc] init];
    textMessage.content = @"这是系统消息";
    textMessage.extra = @"http://www.baidu.com";
    
    if (textMessage.content.length > 0) {
        [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE
                              targetId:self.targetId
                               content:textMessage
                           pushContent:@"{\"pushData\":\"hello\"}"
                              pushData:@""
                               success:^(long messageId) {
                                   
                                   XNLog(@"发送成功");
                                   
                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                   XNLog(@"发送失败");

                               }];
    }

}

#pragma mark - 重写会话页面自定义消息的两个方法

-(RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 自定义消息
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageBaseCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XNSimpleMessageCell class])
                                                                        forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}
-(CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回自定义cell的实际高度
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[XNChatSystemMessage class]]) {
        
        return CGSizeMake(collectionView.frame.size.width,[XNSimpleMessageCell
                                                           getBubbleBackgroundViewSize:(XNChatSystemMessage *)messageContent]
                          .height +
                          66);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}




































@end
