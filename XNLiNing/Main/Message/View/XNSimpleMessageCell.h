//
//  XNSimpleMessageCell.h
//  XNLiNing
//
//  Created by xunan on 2017/3/27.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class XNChatSystemMessage;

/**
 * 文本消息Cell
 */
@interface XNSimpleMessageCell : RCMessageCell

/**
 * 消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;


/*!
 根据消息内容获取显示的尺寸
 
 @param message 消息内容
 
 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(XNChatSystemMessage *)message;

@end
