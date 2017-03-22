//
//  XNRCIMBaseReq.h
//  XNLiNing
//
//  Created by xunan on 2017/3/22.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XNReqeustTypeGet = 1,
    XNReqeustTypePost = 2
}XNReqeustType;

@interface XNRCIMBaseReq : NSObject

+ (void)requestGetWithUrl:(NSString *)urlString
                   params:(NSDictionary *)params
                     type:(XNReqeustType)type
          responseSucceed:(void(^)(NSDictionary *res))succeedBlock
           responseFailed:(void(^)(NSString *error))fieldBlock;


@end
