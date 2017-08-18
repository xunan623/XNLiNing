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
#import <CommonCrypto/CommonDigest.h>

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

#pragma mark - 获取融云Token

+(NSURLSessionTask *)getRCIMToken:(id)parameters
                          success:(XNRequestSuccess)success
                          failure:(XNRequestFailure)failure {
    
    NSString *Nonce = [NSString stringWithFormat:@"%d",arc4random()];
    // 以1970/01/01 GMT为基准时间，返回实例保存的时间与1970/01/01 GMT的时间间隔
    NSString *Timestamp = [NSString stringWithFormat:@"%d",(int)[ [NSDate date] timeIntervalSince1970]];
    // 将系统分配的 AppSecret、Nonce (随机数)、Timestamp (时间戳)三个字符串按先后顺序拼接成一个字符串并进行 SHA1哈希计算
    NSString *Signature = [self sha1:[NSString stringWithFormat:@"%@%@%@", AppRongCloudAppSecret,Nonce,Timestamp]];
    
    // 每次请求 API接口时，均需要提供 4个 HTTP Request Header
    [XNReqeustManager setValue:AppRongCloudAppKey forHTTPHeaderField:@"App-Key"];
    [XNReqeustManager setValue:Nonce forHTTPHeaderField:@"Nonce"];
    [XNReqeustManager setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [XNReqeustManager setValue:Signature forHTTPHeaderField:@"Signature"];
    
    return [XNReqeustManager POST:RCIM_GET_TOKEN parameters:parameters success:^(id responseObject) {
        
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        success(responseObject);

    } failure:^(NSError *error) {
        // 同上
        failure(error);
    }];
}

#pragma mark - 上传多张图片

+ (NSURLSessionTask *)uploadImages:(NSArray<UIImage *> *)images
                         fileNames:(NSArray<NSString *> *)imageNames
                          progress:(XNReqeustProgress)progresses
                           success:(XNRequestSuccess)success
                           failure:(XNRequestFailure)failure {
    
    [XNReqeustManager setResponseSerializer:XNResponseSerializerHTTP];
    return [XNReqeustManager uploadImagesWithURL:AppRequestURL_uploadImages parameters:nil name:@"uploadimg" images:images fileNames:imageNames imageScale:1.0f imageType:@"jpg" progress:^(NSProgress *progress) {
        XNLog(@"%lf",1.0 * progress.completedUnitCount / progress.totalUnitCount);
        progresses ? progresses(progress):nil;
    } success:^(id responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *regex = @"http://chuantu.biz.*?(.jpg|.png)";//正则表达式
        NSRange range = [result rangeOfString:regex options:NSRegularExpressionSearch];
        NSString *resObject;
        if (range.location != NSNotFound) {
            resObject = [result substringWithRange:range];
        } else {
            resObject = @"请求成功,没有获取图片地址";
        }
        [SVProgressHUD showSuccessWithStatus:resObject];

        success ? success(resObject) : nil;

    } failure:^(NSError *error) {
        failure ? failure(error) : nil;
    }];
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

/*使用下面方法需要导入 CommonCrypto/CommonDigest.h*/
//  哈希计算
+ (NSString *)sha1:(NSString *)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
