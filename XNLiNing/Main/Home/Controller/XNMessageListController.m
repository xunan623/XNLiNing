//
//  XNMessageListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNMessageListController.h"

@interface XNMessageListController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation XNMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellname";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

- (IBAction)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
