//
//  XNMessageListController.h
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

//#import <UIKit/UIKit.h>


#import "XNBaseViewController.h"
#import "XNBaseNavigationBar.h"

@interface XNMessageListController : XNBaseViewController

@property (strong, nonatomic) XNBaseNavigationBar *navBar;

- (void)initData;

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime Message:(NSString *)message;



@end
