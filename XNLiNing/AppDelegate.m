//
//  AppDelegate.m
//  XNLiNing
//
//  Created by xunan on 16/9/10.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "AppDelegate.h"
#import "XNLoginController.h"
#import "AppDelegate+Reachability.h"
#import "XNUserDefaults.h"
#import "UIWindow+Extension.h"
#import "AppDelegate+XNRongIMKit.h"
#import "AppDelegate+XNBaiduLocation.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+XN3DTouch.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate+XNThirdPlatform.h"
#import <WXApi.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate ()<WXApiDelegate, WeiboSDKDelegate, QQApiInterfaceDelegate>

@property (strong, nonatomic) NSString *weChatOpenId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 本地存储
    [[RWUserDefaults shareInstance] registerClass:[XNUserDefaults class]];
    
    // 融云相关
    [AppDelegate rong_application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 3dTouch
    [AppDelegate touch_application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 第三方登录
    [self registThirdPlatform];
    
    // 百度地图初始化
    [self baiduLocation_applicationSetUp];
    
    // 检查网络
    [self reachabilityInternet];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 切换控制器
    [self.window switchRootViewController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = ToatalunreadMsgCount;
    
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
}

//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/**
 * 远程推送的token
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
/**
 * 远程推送的内容
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    [AppDelegate rong_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
/**
 * 本地推送的内容
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [AppDelegate rong_application:application didReceiveLocalNotification:notification];
}

/**
 * 3DTouch回调
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    [AppDelegate touch_application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - ApplicationMethod
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSString *absoluteUrlStr = [url absoluteString];
    
    if ([absoluteUrlStr rangeOfString:AppWeChatAppID].location != NSNotFound) {
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if ([absoluteUrlStr rangeOfString:AppWeiboAppKey].location != NSNotFound){
        
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if ([absoluteUrlStr rangeOfString:AppQQAppID].location != NSNotFound){
    
        return [TencentOAuth HandleOpenURL:url];
        
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *absoluteUrlStr = [url absoluteString];
    
    if ([absoluteUrlStr rangeOfString:AppWeChatAppID].location != NSNotFound) { //从“微信”打开“中原找房”
        
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([absoluteUrlStr rangeOfString:AppWeiboAppKey].location != NSNotFound){ //从“微博”打开“中原找房”
        
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([absoluteUrlStr rangeOfString:AppQQAppID].location != NSNotFound){ //从“QQ”打开“中原找房”
        
        [QQApiInterface handleOpenURL:url delegate:self];
        
        if (YES ==  [TencentOAuth CanHandleOpenURL:url]) {
            return [TencentOAuth HandleOpenURL:url];
        }
        return YES;
        
    }
    return YES;
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
    
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin {
    [self.tencentOAuth getUserInfo];
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth
                   withPermissions:(NSArray *)permissions {
    
    if (tencentOAuth) [tencentOAuth authorize:permissions
                                     inSafari:NO];
    return NO;
}

-(void)getUserInfoResponse:(APIResponse *)response {
    NSDictionary *responseDic = response.jsonResponse;
    
    XNLog(@"%@",response.jsonResponse);
    
    ///用户头像
    NSString *userHeadImgUrl = [NSString stringWithFormat:@"%@",
                                [responseDic valueForKey:@"figureurl_qq_2"]];
    
    ///用户昵称
    NSString *userNickName = [NSString stringWithFormat:@"%@",
                              [responseDic valueForKey:@"nickname"]];
    
    self.qqOpenId = [NSString stringWithFormat:@"%@",self.tencentOAuth.openId];
    
    self.thirdPlatformNickName = userNickName;
    
    self.thirdPlatformHeadImgUrl = userHeadImgUrl;
    
    [self setThirdPlatformLoginResult:YES];
    
    [XNAlertView showWithTitle:@"登录成功"];
    
}

- (void)isOnlineResponse:(NSDictionary *)response {

}

/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (!cancelled) {
        XNLog(@"第三方登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    
    XNLog(@"请求失败");
}

#pragma mark - WeChatDelegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(id)resp {
    if ([resp isKindOfClass:[QQBaseResp class]]) { // QQ
        [self onQQResp:resp];
    } else if ([resp isKindOfClass:[BaseResp class]]) { // 微信
        [self onWeChatResp:resp];
    }
}
- (void)onQQResp:(QQBaseResp *)resp {  //QQ分享结果
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]]){ // qq分享
        if (resp.type == ESENDMESSAGETOQQRESPTYPE  && [resp.result integerValue] == 0) {  //分享成功
            [XNAlertView showWithTitle:@"QQ分享成功"];
        }else{  //取消分享
            [XNAlertView showWithTitle:@"QQ取消分享"];
        }
    }
}

-(void)onWeChatResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { // 微信分享
        resp.errCode == WXSuccess ? [XNAlertView showWithTitle:@"微信分享成功"] : [XNAlertView showWithTitle:@"微信分享失败"];
    } else if ([resp isKindOfClass:[SendAuthResp class]]) { // 微信登录
        __weak typeof(self) weakSelf = self;
        // 1.获取微信授权code
        SendAuthResp *weChatResp = (SendAuthResp *)resp;
        if (weChatResp.code) {
            NSDictionary *params = @{@"appid" : AppWeChatAppID,
                                     @"secret": AppWeChatAppSecret,
                                     @"code"  : weChatResp.code,
                                     @"grant_type" : @"authorization_code"};
            
            [XNBaseReq requestGetWithUrl:AppRequestURL_WeiXin_Token
                                  params:params responseSucceed:^(NSDictionary *res) {
                 NSString *accessToken = (NSString *)res[@"access_token"];
                 weakSelf.weChatOpenId = (NSString *)res[@"openid"];
                  if (weakSelf.weChatOpenId.length && accessToken.length) {
                      [weakSelf weixinOAuthSuccessWithAccessToken:accessToken weixinOpenId:weakSelf.weChatOpenId];
                  }
            } responseFailed:^(NSString *error) {
                XNLog(@"获取token失败:%@", error);
            }];
        }
    }
}
///最后一步：获取微信用户信息
-(void)weixinOAuthSuccessWithAccessToken:(NSString *)accessToken weixinOpenId:(NSString *)weixinOpenId {
    WeakSelf(weakSelf);
    NSDictionary *params = @{@"openid" : weixinOpenId,
                             @"access_token" : accessToken
                             };
    [XNBaseReq requestGetWithUrl:AppRequestURL_WeiXin_UserInfo params:params responseSucceed:^(NSDictionary *res) {
        
        weakSelf.thirdPlatformNickName = (NSString *)res[@"nickname"];
        weakSelf.thirdPlatformHeadImgUrl = (NSString *)res[@"headimgurl"];
        [weakSelf setThirdPlatformLoginResult:YES];
        [XNAlertView showWithTitle:@"获取用户信息成功"];
    } responseFailed:^(NSString *error) {
        XNLog(@"获取用户信息失败:%@", error);
        [weakSelf setThirdPlatformLoginResult:NO];

    }];
}


#pragma mark - WeiboDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        
        WBSendMessageToWeiboResponse *sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse *)response;
        
        switch (sendMessageToWeiboResponse.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
                [XNAlertView showWithTitle:@"分享成功"];
                break;
                
            default:
                [XNAlertView showWithTitle:@"取消分享"];
                break;
        }
        
    } else if([response isKindOfClass:[WBAuthorizeResponse class]]) {
        
        WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
        
        switch (authResponse.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess: {
                NSDictionary *params = @{@"uid"          : authResponse.userID,
                                         @"access_token" : authResponse.accessToken};
                [XNBaseReq requestGetWithUrl:AppRequestURL_Weibo_UserInfo params:params responseSucceed:^(NSDictionary *res) {
                    XNLog(@"请求微博用户信息成功:%@", res);
                    self.qqOpenId = [NSString stringWithFormat:@"%@",authResponse.userID];
                    
                    self.thirdPlatformNickName = res[@"screen_name"];
                    
                    self.thirdPlatformHeadImgUrl = res[@"avatar_large"];
                    
                    [self setThirdPlatformLoginResult:YES];
                    
                    [XNAlertView showWithTitle:@"登录成功"];
                } responseFailed:^(NSString *error) {
                    [XNAlertView showWithTitle:error];
                }];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel: {
                //用户取消
            }
                break;
                
            default:
                break;
        }
    }
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}







































@end
