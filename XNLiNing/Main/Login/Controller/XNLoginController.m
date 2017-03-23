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
#import "XNSaveUserDefault.h"
#import "UIWindow+Extension.h"
#import <WHC_ModelSqlite.h>
#import "XNSaveModel.h"

@interface XNLoginController ()<UITextFieldDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UIButton *submmitBtn;

@end

@implementation XNLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WHCSqlite removeAllModel];
    NSDictionary *dict = @{ @"failMessage" : @"请求成功",
                            @"maxPage"     : @"1",
                            @"userId"      : [XNUserDefaults new].userName ? [XNUserDefaults new].userName : @"",
                            @"retVal"      : @"0",
                            @"record"      : @"新字段",
                            @"content"     : @{ @"name"     : @"许楠",
                                                @"age"      : @(18),
                                                @"height"   : @58.4
                                                }
                           };
    XNSaveModel *model = [[XNSaveModel alloc] initWithDictionary:dict error:nil];
    XNLog(@"%@----",model);
    
    // 插入
    [WHCSqlite insert:model];
    
    NSArray *queryArray = [WHCSqlite query:[XNSaveModel class]];
    XNLog(@"%@-----jaskdlfj", queryArray);
    
    /// 9.1 获取数据库版本号
    NSString * version = [WHCSqlite versionWithModel:[XNSaveModel class]];
    XNLog(@"version = %@",version);
    
    /// 8.1 获取数据库本地路径
    NSString * path = [WHCSqlite localPathWithModel:[XNSaveModel class]];
    XNLog(@"localPath = %@",path);
    
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
        [self.submmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submmitBtn.userInteractionEnabled = YES;
    } else {
        [self.submmitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.submmitBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 请求接口
- (IBAction)submitClick:(UIButton *)sender {
    XNLog(@"提交按钮");
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;
    NSDictionary *params = @{@"param.userName" : self.userNameField.text,
                             @"param.passWord" : self.passwordFiled.text,
                             @"param.from"     : @"iOS",
                             @"param.version"  : [XNSimpleTool getApplyVersion]};
    
    [XNBaseReq requestGetWithUrl:AppRequestURL_loginApp
                          params:params
                 responseSucceed:^(NSDictionary *res) {
                     
        XNLoginModel *model = [[XNLoginModel alloc] initWithDictionary:res error:nil];
        if ([model.retVal boolValue]) {
            
            [XNSaveUserDefault saveUserDefaultWith:model.userInfo];
            
            [XNAlertView  showWithTitle:model.failMessage done:^{
                
                XNTabbarController *tabbarVC = [[XNTabbarController alloc] init];
                tabbarVC.transitioningDelegate = self;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = tabbarVC;
                
                [window saveVersionToNSUserDefault];
                
                [[XNRCDataManager shareManager] getTokenAndLoginRCIM];
            }];
        } else {
            
   
            [XNAlertView showWithTitle:model.failMessage done:^{
                sender.userInteractionEnabled = YES;
                
                // 新增代码
                XNUserDefaults *ud = [XNUserDefaults new];
                ud.userName = self.userNameField.text;
                ud.userPassword = self.passwordFiled.text;

                XNTabbarController *tabbarVC = [[XNTabbarController alloc] init];
                tabbarVC.transitioningDelegate = self;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = tabbarVC;
                
                [window saveVersionToNSUserDefault];
                
                [[XNRCDataManager shareManager] getTokenAndLoginRCIM];
            }];;
        }
                     
    } responseFailed:^(NSString *error) {
        XNLog(@"%@", error);
        sender.userInteractionEnabled = YES;
        [XNAlertView showWithTitle:error];
    
    }];
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
