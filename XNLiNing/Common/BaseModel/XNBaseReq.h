//
//  XNBaseReq.h
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface XNBaseReq : JSONModel

+ (void)requestGetWithUrl:(NSString *)urlString
                params:(NSDictionary *)params
          responseSucceed:(void(^)(NSDictionary *res))succeedBlock
           responseFailed:(void(^)(NSString *error))fieldBlock;


@end
