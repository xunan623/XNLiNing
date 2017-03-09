//
//  XNSettingCollectionHeaderView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingCollectionHeaderView.h"
#import "XNLoginController.h"

@interface XNSettingCollectionHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UIButton *msgLabel1;
@property (weak, nonatomic) IBOutlet UIButton *msgLabel2;
@property (weak, nonatomic) IBOutlet UIButton *msgLabel3;

@end

@implementation XNSettingCollectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rw_width = XNScreen_Width;
    self.rw_height = 200;
    
    XNUserDefaults *ud = [XNUserDefaults new];
    if (ud.userName.length && ud.userPassword.length) { // 登录过
        self.nameTitle.text = ud.userName;
        [self.msgLabel1 setTitle:ud.userXingming forState:UIControlStateNormal];
        [self.msgLabel2 setTitle:ud.modiyfUser forState:UIControlStateNormal];
        [self.msgLabel3 setTitle:ud.bigArea forState:UIControlStateNormal];
    } else {
        self.nameTitle.text = @"点击头像登录";
    }
    UITapGestureRecognizer *headerImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImage:)];
    [self.headerImage addGestureRecognizer:headerImageTap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rw_width = XNScreen_Width;
    self.rw_height = 200;
}
#pragma mark - 点击头像登录
- (IBAction)tapHeaderImage:(UITapGestureRecognizer *)sender {
    if (![XNUserDefaults new].userPassword.length) return;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    XNLoginController *loginVC = [[XNLoginController alloc] init];
    window.rootViewController = loginVC;
}
@end
