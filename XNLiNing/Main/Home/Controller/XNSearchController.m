//
//  XNSearchController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/16.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSearchController.h"


@interface XNSearchController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation XNSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

- (IBAction)cancelClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
