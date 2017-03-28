//
//  AppDelegate+XNBaiduLocation.m
//  XNLiNing
//
//  Created by xunan on 2017/3/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+XNBaiduLocation.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate()<BMKGeneralDelegate>

@end


@implementation AppDelegate (XNBaiduLocation)

- (void)baiduLocation_applicationSetUp {

    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:BAIDU_APP_KEY generalDelegate:self];
    
    if (!ret) {
        XNLog(@"BaiduMapManager start failed!");
    }
}

@end
