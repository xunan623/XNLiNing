//
//  XNChatSystemMessage.h
//  XNLiNing
//
//  Created by xunan on 2017/3/27.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RTLocalMessage @"RT:SimpleMsg"

@interface XNChatSystemMessage : RCMessageContent<NSCoding, RCMessageContentView>

/** 文本消息内容 */
@property (nonatomic, copy) NSString *content;

/** 附加信息 */
@property (nonatomic, copy) NSString *extra;

+ (instancetype)messageWithContent:(NSString *)content;

@end
