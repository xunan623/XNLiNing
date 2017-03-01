//
//  UITextField+Ext.m
//  XNToolDemo
//
//  Created by xunan on 2016/12/26.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import "UITextField+Ext.h"
#import "NSObject+Notification.h"

@implementation UITextField (Ext)

- (void)limitTextMaxLength:(NSInteger)len {
    [self rw_observeNotification:UITextFieldTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        if (self.text.length > len) {
            [self deleteBackward];
        }
    }];
}

@end
