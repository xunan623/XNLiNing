//
//  XNBaseReq.h
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import <AFNetworking.h>
#import "XNReqeustManager.h"

typedef void(^XNRequestSuccess)(id response);

typedef void(^XNRequestFailure)(NSError *error);

typedef void(^XNReqeustProgress)(NSProgress *progress);

@interface XNBaseReq : JSONModel


/** 登录接口 */
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters
                                     success:(XNRequestSuccess)success
                                     failure:(XNRequestFailure)failure;

/** 微信Token */
+ (NSURLSessionTask *)getWeChatToken:(id)parameters
                             success:(XNRequestSuccess)success
                             failure:(XNRequestFailure)failure;

/** 获取微信用户信息 */
+ (NSURLSessionTask *)getWeChatUserInfo:(id)parameters
                                success:(XNRequestSuccess)success
                                failure:(XNRequestFailure)failure;

/** 获取微博用户信息 */
+ (NSURLSessionTask *)getWeiBoUserInfo:(id)parameters
                               success:(XNRequestSuccess)success
                               failure:(XNRequestFailure)failure;

/** 融云token获取 */
+(NSURLSessionTask *)getRCIMToken:(id)parameters
                          success:(XNRequestSuccess)success
                          failure:(XNRequestFailure)failure;

/** 上传多图片 */
+ (NSURLSessionTask *)uploadImages:(NSArray<UIImage *> *)images
                         fileNames:(NSArray<NSString *> *)imageNames
                          progress:(XNReqeustProgress)progresses
                           success:(XNRequestSuccess)success
                           failure:(XNRequestFailure)failure;


@end
