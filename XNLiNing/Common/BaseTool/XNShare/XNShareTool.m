//
//  XNShareTool.m
//  XNLiNing
//
//  Created by xunan on 2017/4/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShareTool.h"
#import <WXApi.h>
#import <WXApiObject.h>
#import <UIImageView+WebCache.h>
#import <objc/message.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface XNShareTool()

@property (nonatomic, assign) enum WXScene scene;

@end

@implementation XNShareTool


+ (void)shareWithTilte:(NSString *)title linkUrl:(NSString *)linkUrl imageUrl:(NSString *)imageUrl type:(XNShareTypeGroup)type {
    switch (type) {
        case XNShareTypeGroupQQ: {
            [self sendQQLink:title linkUrl:linkUrl imageUrl:imageUrl type:XNShareTypeGroupQQ];

        }
            break;
        case XNShareTypeGroupWeChatFriend: {
            [self sendWeChatLink:title linkUrl:linkUrl imageUrl:imageUrl type:XNShareTypeGroupWeChatFriend];
        }
            break;
        case XNShareTypeGroupWeChat: {
            [self sendWeChatLink:title linkUrl:linkUrl imageUrl:imageUrl type:XNShareTypeGroupWeChat];
        }
            break;
        case XNShareTypeGroupWeibo: {
            [self sendWeiboLink:title linkUrl:linkUrl imageUrl:imageUrl type:XNShareTypeGroupWeibo];
        }
            break;
        default:
            break;
    }
}

+ (void)sendWeChatLink:(NSString *)title linkUrl:(NSString *)linkUrl imageUrl:(NSString *)urlString type:(XNShareTypeGroup)type{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        error ? [message setThumbImage:[UIImage imageNamed:@"Share_Default"]] :[message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = linkUrl;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        type == XNShareTypeGroupWeChat ? (req.scene = 1) : (req.scene = 0);
        req.bText = NO;
        req.message = message;
        [WXApi sendReq:req];
    }];
}

+ (void)sendWeiboLink:(NSString *)title linkUrl:(NSString *)linkUrl imageUrl:(NSString *)urlString type:(XNShareTypeGroup)type {
    if (![WeiboSDK isWeiboAppInstalled]) {
        [WeiboSDK openWeiboApp];
    }else {
        WBMessageObject *message = [WBMessageObject message];
        message.text = title;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            // 消息的图片内容中，图片数据不能为空并且大小不能超过10M
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
            error ? (imageObject.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"Share_Default"], 1.0)) : (imageObject.imageData = UIImageJPEGRepresentation(image, 1.0));
            message.imageObject = imageObject;

            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }];
        

    }
}

+ (void)sendQQLink:(NSString *)title linkUrl:(NSString *)linkUrl imageUrl:(NSString *)urlString type:(XNShareTypeGroup)type {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //用于分享图片内容的对象
        if (error) {
            image = [UIImage imageNamed:@"Share_Default"];
        }
        
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(image, 1.0)
                                                   previewImageData:nil
                                                              title:title
                                                        description:@"哈哈"];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        
        [QQApiInterface sendReq:req];
        
    }];

    
}














@end
