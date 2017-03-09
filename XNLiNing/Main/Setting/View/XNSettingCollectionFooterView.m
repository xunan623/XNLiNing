//
//  XNSettingCollectionFooterView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingCollectionFooterView.h"

@interface XNSettingCollectionFooterView()

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;


@end

@implementation XNSettingCollectionFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    XNUserDefaults *ud = [XNUserDefaults new];
    if (ud.userName.length) {
        [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    } else {
        [self.exitBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    
}
- (IBAction)exitClick {
    if ([self.exitBtn.titleLabel.text isEqualToString:@"退出登录"]) {
        if (self.block) {
            self.block(YES);
        }
    } else {
        if (self.block) {
            self.block(NO);
        }
    }
}

- (void)setBlock:(CollectionFooterViewBlock)block {
    _block = block;
}

@end
