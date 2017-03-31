//
//  XNShareView.h
//  XNLiNing
//
//  Created by xunan on 2017/3/31.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    XNShareTypeQQ = 10,                 // QQ
    XNShareTypeWeChatFriend = 20,       // 微信好友
    XNShareTypeWeChatFriends = 30,      // 微信朋友圈
    XNShareTypeWeiBo = 40               // 微博分享
}XNShareType;

@interface XNShareView : UIView

+ (instancetype)msGetInstance;

- (void)show;

- (void)hide;
@end
