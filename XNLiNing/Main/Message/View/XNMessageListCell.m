//
//  XNMessageListCell.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNMessageListCell.h"

@implementation XNMessageListCell

@synthesize model = _model;


+ (instancetype)msGetInstance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:0] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unReadBadge.hidden = YES;
}

- (void)setModel:(RCConversationModel *)model {
    _model = model;
    
    // 未读消息数
    long long badgeNum = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:model.targetId];
    if (badgeNum > 0) {
        self.unReadBadge.hidden = NO;
        if (badgeNum >99) {
            self.unReadBadge.text = @"99+";
        } else {
            self.unReadBadge.text = [NSString stringWithFormat:@"%lld",badgeNum];;
        }
    } else {
        self.unReadBadge.hidden = YES;
        self.unReadBadge.text = @"0";
    }
    
    // 用户id
    self.nameLabel.text = model.targetId;
    
    // 时间
    self.timeLabel.text = [NSDate calculateMessageTimeWithSendInterval:model.sentTime
                                                    andReceiveInterval:model.receivedTime];
    
    // 消息体
    if ([model.lastestMessage isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *chatMessage = (RCTextMessage *)model.lastestMessage;
        self.detailLabel.text = chatMessage.content;
    }else if ([model.lastestMessage isMemberOfClass:[RCImageMessage class]]){
        self.detailLabel.text = @"[图片]";
    } else if ([model.lastestMessage isMemberOfClass:[RCLocationMessage class]]){
        self.detailLabel.text = @"[位置]";
    } else if ([model.lastestMessage isMemberOfClass:[RCVoiceMessage class]]){
        self.detailLabel.text = @"[语音]";
    } else{
        self.detailLabel.text = @"";
    }
    
    

}







































@end
