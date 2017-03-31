//
//  AppDelegate+XNThirdPlatform.m
//  XNLiNing
//
//  Created by xunan on 2017/3/30.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XNThirdPlatform.h"
#import <WXApi.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate()<WXApiDelegate, WeiboSDKDelegate,TencentLoginDelegate, TencentSessionDelegate, QQApiInterfaceDelegate>


@end

@implementation AppDelegate (XNThirdPlatform)



/** 第三方登录注册 */
-(void)registThirdPlatform {
    
    [WXApi registerApp:AppWeChatAppID];
    
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:AppQQAppID andDelegate:self];
    self.tencentOAuth = tencentOAuth;

    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:AppWeiboAppKey];
}

- (void)OAuthQQMethod {
    NSArray * permissions =  [NSArray arrayWithObjects:
                              kOPEN_PERMISSION_GET_USER_INFO,
                              kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                              kOPEN_PERMISSION_GET_INFO,nil];
    
    [self.tencentOAuth authorize:permissions localAppId:AppQQAppID inSafari:NO];

}


@end
