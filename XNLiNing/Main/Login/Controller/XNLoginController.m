//
//  XNLoginController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLoginController.h"
#import "XNTabbarController.h"
#import "XNBaseReq.h"
#import <JSONModel.h>
#import "XNLoginModel.h"

@interface XNLoginController ()<UITextFieldDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UIButton *submmitBtn;


@end

@implementation XNLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    _userNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    _userNameField.leftViewMode = UITextFieldViewModeAlways;
    _passwordFiled.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    _passwordFiled.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark - TextFieldDelegate
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (_userNameField.text.length >=4 && _passwordFiled.text.length >= 6) {
        self.submmitBtn.backgroundColor = XNAPPNormalColor;
        
        self.submmitBtn.userInteractionEnabled = YES;
    } else {
        self.submmitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submmitBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 请求接口
- (IBAction)submitClick:(UIButton *)sender {
    XNLog(@"提交按钮");
    
    NSDictionary *params = @{@"param.userName" : self.userNameField.text,
                             @"param.passWord" : self.passwordFiled.text,
                             @"param.from"     : @"iOS",
                             @"param.version"  : [XNSimpleTool getApplyVersion]};
    
    [XNBaseReq requestGetWithUrl:AppRequestURL_loginApp
                          params:params
                 responseSucceed:^(NSDictionary *res) {
                     [XNAlertView showWithTitle:@"请求成功"];
        XNLoginModel *model = [[XNLoginModel alloc] initWithDictionary:res error:nil];
        if ([model.retVal boolValue]) {
                     
        } else {
            
        }
                     
    } responseFailed:^(NSString *error) {
        XNLog(@"%@", error);
        [XNAlertView showWithTitle:error];
    
    }];
    
    XNTabbarController *tabbarVC = [[XNTabbarController alloc] init];
    tabbarVC.transitioningDelegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarVC;
    

}



@end
