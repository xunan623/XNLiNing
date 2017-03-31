//
//  AppDelegate.h
//  XNLiNing
//
//  Created by xunan on 16/9/10.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) TencentOAuth *tencentOAuth;

///第三方登录结果（包括：微信、QQ、微博）
@property (nonatomic,assign) BOOL thirdPlatformLoginResult;

///第三方账号的昵称
@property (nonatomic,strong) NSString *thirdPlatformNickName;

///第三方账号的头像
@property (nonatomic,strong) NSString *thirdPlatformHeadImgUrl;

/** QQOpenId */
@property (nonatomic, strong) NSString *qqOpenId;



@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain) NSMutableArray *friendsArray;

+ (AppDelegate* )shareAppDelegate;

@end

