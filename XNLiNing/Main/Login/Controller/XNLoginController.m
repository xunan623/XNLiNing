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
#import "AppDelegate+XNThirdPlatform.h"
#import <WeiboSDK.h>
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>



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
- (IBAction)QQbtnClick:(UIButton *)sender {
    [[AppDelegate shareAppDelegate] OAuthQQMethod];
}
- (IBAction)sinaClick {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = AppWeiboRedirectUrl;
    request.scope = @"all";
    request.userInfo = @{AppWeiboAppKey:AppWeiboAppSecret};
    [WeiboSDK sendRequest:request];
}
- (IBAction)weiChatClick {
    SendAuthReq *requestItem = [[SendAuthReq alloc]init];
    requestItem.scope = @"snsapi_userinfo";
    requestItem.state = AppWeChatAppID;
    [WXApi sendReq:requestItem];

}

#pragma mark - 请求接口
- (IBAction)submitClick:(UIButton *)sender {
    XNLog(@"提交按钮");
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;

    NSDictionary *params = @{@"param.userName" : self.userNameField.text,
                             @"param.passWord" : self.passwordFiled.text,
                             @"param.from"     : @"iOS",
                             @"param.version"  : [XNSimpleTool getApplyVersion]};
    
    [XNBaseReq requestGetWithUrl:AppRequestURL_loginApp
                          params:params
                 responseSucceed:^(NSDictionary *res) {
                     
        XNLoginModel *model = [[XNLoginModel alloc] initWithDictionary:res error:nil];
                     
        if ([model.retVal boolValue]) [XNSaveUserDefault saveUserDefaultWith:model.userInfo];
        
        [weakSelf setRootVC:model.failMessage];
                     
    } responseFailed:^(NSString *error) {
        XNLog(@"%@", error);
        [weakSelf setRootVC:error];

    
    }];
}

- (void)setRootVC:(NSString *)msg {
    __weak typeof(self) weakSelf = self;
    [XNAlertView showWithTitle:msg done:^{
        weakSelf.submmitBtn.userInteractionEnabled = YES;
        
        // 新增代码
        XNUserDefaults *ud = [XNUserDefaults new];
        ud.userName = weakSelf.userNameField.text;
        ud.userPassword = weakSelf.passwordFiled.text;
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window saveVersionToNSUserDefault];
        
        [[XNRCDataManager shareManager] getTokenAndLoginRCIM:^(BOOL isSuccess) {
            if (isSuccess) {
                XNLog(@"链接成功");
            }
            [[XNRCDataManager shareManager] refreshBadgeValue];
            
            XNTabbarController *tabbarVC = [[XNTabbarController alloc] init];
            tabbarVC.transitioningDelegate = self;
            window.rootViewController = tabbarVC;
        }];
    }];;
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
