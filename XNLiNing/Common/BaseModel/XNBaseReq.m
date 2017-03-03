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

@implementation XNBaseReq

+ (void)requestGetWithUrl:(NSString *)urlString
                params:(NSDictionary *)params
       responseSucceed:(void(^)(NSDictionary *res))succeedBlock
        responseFailed:(void(^)(NSString *error))fieldBlock {

    // 1.先检查网络
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if (reach.currentReachabilityStatus == NotReachable) {
        if (fieldBlock) fieldBlock(@"无网络连接");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@", AppRequestURL, urlString];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",nil];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        XNLog(@"%@ \n \n %@", responseObject, responseObject.mj_JSONString);
        if (succeedBlock) succeedBlock(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (fieldBlock) fieldBlock([error localizedDescription]);
    }];
}

@end
