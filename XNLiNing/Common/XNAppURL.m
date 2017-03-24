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



NSString *const BAIDU_APP_KEY = @"Md0ImUWsr0UGodO3NB5MdiAWumvGcfxx";                                // 百度地图key

@end
