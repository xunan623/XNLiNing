//
//  XNRCIMBaseReq.m
//  XNLiNing
//
//  Created by xunan on 2017/3/22.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNRCIMBaseReq.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <Reachability.h>
#import <MJExtension.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XNRCIMBaseReq


+ (void)requestGetWithUrl:(NSString *)urlString
                   params:(NSDictionary *)params
                     type:(XNReqeustType)type
          responseSucceed:(void(^)(NSDictionary *res))succeedBlock
           responseFailed:(void(^)(NSString *error))fieldBlock {
    
    // 1.先检查网络
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach.currentReachabilityStatus == NotReachable) {
        if (fieldBlock) fieldBlock(@"无网络连接");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
    // 随机数，无长度限制
    NSString *Nonce = [NSString stringWithFormat:@"%d",arc4random()];
    // 以1970/01/01 GMT为基准时间，返回实例保存的时间与1970/01/01 GMT的时间间隔
    NSString *Timestamp = [NSString stringWithFormat:@"%d",(int)[ [NSDate date] timeIntervalSince1970]];
    // 将系统分配的 AppSecret、Nonce (随机数)、Timestamp (时间戳)三个字符串按先后顺序拼接成一个字符串并进行 SHA1哈希计算
    NSString *Signature = [self sha1:[NSString stringWithFormat:@"%@%@%@", AppRongCloudAppSecret,Nonce,Timestamp]];
    
    // 每次请求 API接口时，均需要提供 4个 HTTP Request Header
    [manager.requestSerializer setValue:AppRongCloudAppKey forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:Nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:Timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    
    switch (type) {
        case XNReqeustTypeGet: {
            [manager GET:RCIM_TOKEN parameters:params progress:nil
                 success:^(NSURLSessionDataTask * task, id responseObject) {
                    
                NSError *error;
                NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
                 if (error) {
                     XNLog(@"%@", error);
                 } else {
                     if (succeedBlock) succeedBlock(dic);
                 }
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                if (fieldBlock) fieldBlock([error localizedDescription]);

            }];
        }
            break;
        case XNReqeustTypePost: {
            [manager POST:RCIM_GET_TOKEN parameters:params progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
                      
                  NSError *error;
                  NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
                  if (error) {
                      XNLog(@"%@", error);
                  } else {
                      if (succeedBlock) succeedBlock(dic);
                  }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
                if (fieldBlock) fieldBlock([error localizedDescription]);
            }];
        }
            break;
        default:
            break;
    }
    
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
