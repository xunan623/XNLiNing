//
//  UITableView+EmptyData.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

- (void)tableViewDisplayWithMsg:(NSString *)msg withRowCount:(NSUInteger)count {
    if (count == 0) {
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = msg;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.backgroundView = messageLabel;
    } else {
        self.backgroundView = nil;
    }
}

@end
