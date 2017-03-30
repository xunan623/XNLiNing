//
//  XNAppURL.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNAppURL.h"

@implementation XNAppURL
#ifdef DEBUG
NSString *const AppRequestURL = @"http://124.207.27.112/vi/app/";
//NSString *const AppRequestURL = @"http://lnrts.li-ning.com.cn/vi/app/";

NSString *const AppRongCloudAppKey = @"qd46yzrfq02of";
NSString *const AppRongCloudAppSecret = @"4ax8XsLDA1ch";
NSString *const AppWeChatAppID = @"wxb7c1f4edb7e5eaf8";
NSString *const AppWeChatAppSecret = @"eb21a4c55ef3dcc19eb519443bef4fd2";
NSString *const AppQQAppID = @"1105582312";
NSString *const AppQQAppKey = @"jCEn8lFrgw7u3eva";
NSString *const AppWeiboAppKey = @"1931998880";
NSString *const AppWeiboAppSecret = @"de11143c7f6b6d39c24ccd3f5ef54426";
NSString *const AppWeiboRedirectUrl = @"https://api.weibo.com/oauth2/default.html";

#else

NSString *const AppRequestURL = @"http://lnrts.li-ning.com.cn/vi/app/";
NSString *const AppRongCloudAppKey = @"qd46yzrfq02of";
NSString *const AppRongCloudAppSecret = @"4ax8XsLDA1ch";

#endif

NSString *const AppRequestURL_ContactTree = @"getOrgansanListByUpdateApp.action?param.maxPage=0&param.currPage=0";
NSString *const AppRequestURL_imagePath = @"imageVsApp.action?picPath=";
NSString *const AppRequestURL_loginApp = @"loginApp.action";
NSString *const AppRequestURL_infoApp = @"infoApp.action";
NSString *const AppRequestURL_attApp = @"attApp.action";
NSString *const AppRequestURL_dictApp = @"dictApp.action";
NSString *const AppRequestURL_itemApp = @"itemApp.action";
NSString *const AppRequestURL_followApp = @"followUpApp.action";
NSString *const AppRequestURL_shopListApp = @"shopListApp.action";
NSString *const AppRequestURL_shopIdListApp = @"shopIdListApp.action";
NSString *const AppRequestURL_uploadApp = @"upload.action";
NSString *const AppRequestURL_savePicInfoApp = @"savePicInfoApp.action";
NSString *const AppRequestURL_downloadFileMobileApp = @"downloadFileMobileAction.action";
NSString *const AppRequestURL_updateInfoApp = @"updateInfoApp.action";
NSString *const AppRequestURL_findUserInfoApp = @"findUserInfoApp.action";
NSString *const AppRequestURL_getItemImgsApp = @"getItemImgsApp.action";
NSString *const AppRequestURL_reportApp = @"reportApp.action";




NSString *const RCIM_TOKEN = @"RCIM_TOKEN";
NSString *const RCIM_GET_TOKEN = @"https://api.cn.rong.io/user/getToken.json";
NSString *const RCIM_LOCATIONPUSH_ID = @"RCIM_LOCATIONPUSH_ID";                                     // 本地推送key
NSString *const RCIM_LOCATIONPUSH_CONTENT = @"RCIM_LOCATIONPUSH_CONTENT";                           // 融云本地推送content




NSString *const BAIDU_APP_KEY = @"Md0ImUWsr0UGodO3NB5MdiAWumvGcfxx";                                // 百度地图key

@end
