//
//  XNLoginController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNLoginController.h"
#import "XNLoginTranslation.h"
#import "XNTabbarController.h"

@interface XNLoginController ()<UITextFieldDelegate, UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UIButton *submmitBtn;
@property (strong, nonatomic) XNLoginTranslation* login;

@end

@implementation XNLoginController

- (XNLoginTranslation *)login {
    if (!_login) {
        _login = [[XNLoginTranslation alloc] initWithView:self.submmitBtn];

    }
    return _login;
}

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
    if (_userNameField.text.length > 6 && _passwordFiled.text.length > 6) {
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
    
    XNTabbarController *tabbarVC = [[XNTabbarController alloc] init];
    tabbarVC.transitioningDelegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbarVC;
    
    [self performSelectorOnMainThread:@selector(finishAnimation) withObject:nil waitUntilDone:10];

}

- (void)finishAnimation {
    [self.login stopAnimation];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.login.reverse = YES;
    return self.login;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.login.reverse = NO;
    return self.login;
}

@end
