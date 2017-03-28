//
//  XNChatController.h
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XNChatController : RCConversationViewController

/** 是否需要自己发送信息 */
@property (nonatomic, copy) NSString *messageContent;

@end
