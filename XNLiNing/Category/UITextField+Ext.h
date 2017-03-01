//
//  UITextField+Ext.h
//  XNToolDemo
//
//  Created by xunan on 2016/12/26.
//  Copyright © 2016年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Ext)

/**
 文字内容限制最大长度
 */
- (void)limitTextMaxLength:(NSInteger)len;

@end
