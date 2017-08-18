//
//  XNBaseReq.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseReq.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <Reachability.h>
#import <MJExtension.h>
#import "XNReqeustManager.h"

@implementation XNBaseReq

#pragma mark - 登录接口

+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters
                                     success:(XNRequestSuccess)success
                                     failure:(XNRequestFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",AppRequestURL,AppRequestURL_loginApp];
    return [self requestWithURL:url parameters:parameters success:success failure:failure];
}

#pragma mark - 微信Token

+ (NSURLSessionTask *)getWeChatToken:(id)parameters
                             success:(XNRequestSuccess)success
                             failure:(XNRequestFailure)failure {

    return [self requestWithURL:AppRequestURL_WeiXin_Token parameters:parameters success:success failure:failure];
}

#pragma mark - 获取微信用户信息

+ (NSURLSessionTask *)getWeChatUserInfo:(id)parameters
                                success:(XNRequestSuccess)success
                                failure:(XNRequestFailure)failure {
    return [self requestWithURL:AppRequestURL_WeiXin_UserInfo parameters:parameters success:success failure:failure];
}

#pragma mark - 获取微博信息

+ (NSURLSessionTask *)getWeiBoUserInfo:(id)parameters
                               success:(XNRequestSuccess)success
                               failure:(XNRequestFailure)failure {
    return [self requestWithURL:AppRequestURL_Weibo_UserInfo parameters:parameters success:success failure:failure];
}

+ (NSURLSessionTask *)requestWithURL:(NSString *)URL
                          parameters:(NSDictionary *)parameters
                             success:(XNRequestSuccess)success
                             failure:(XNRequestFailure)failure {
    [XNReqeustManager setRequestTimeoutInterval:10.0f];
    
    return [XNReqeustManager GET:URL parameters:parameters success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);

    } failure:^(NSError *error) {
        // 同上
        failure(error);
    }];
}

@end
