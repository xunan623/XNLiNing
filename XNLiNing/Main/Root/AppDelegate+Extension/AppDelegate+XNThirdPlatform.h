//
//  AppDelegate+XNThirdPlatform.h
//  XNLiNing
//
//  Created by xunan on 2017/3/30.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate (XNThirdPlatform)

/** 第三方登录注册 */
-(void)registThirdPlatform;

/** 授权QQ */
-(void)OAuthQQMethod;


@end
