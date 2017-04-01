//
//  XNShareTool.h
//  XNLiNing
//
//  Created by xunan on 2017/4/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XNShareTypeGroupQQ = 1,                  // QQ分享
    XNShareTypeGroupWeChatFriend = 2,        // 微信好友分享
    XNShareTypeGroupWeChat = 3,              // 微信朋友圈
    XNShareTypeGroupWeibo = 4                // 微博分享
}XNShareTypeGroup;

@interface XNShareTool : NSObject

+ (void)shareWithTilte:(NSString *)title linkUrl:(NSString *)linkUrl imageUrl:(NSString *)imageUrl type:(XNShareTypeGroup)type;

@end
