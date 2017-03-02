//
//  AppDelegate+Reachability.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "AppDelegate+Reachability.h"
#import <Reachability.h>

@implementation AppDelegate (Reachability)


- (void)reachabilityInternet {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"https://www.baidu.com"];
    [hostReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            XNLog(@"无网络连接");
            break;
        case ReachableViaWiFi:
            XNLog(@"Wifi");
            break;
        case ReachableViaWWAN:
            XNLog(@"移动流量");
            break;
            
        default:
            break;
    }
    

}

@end
