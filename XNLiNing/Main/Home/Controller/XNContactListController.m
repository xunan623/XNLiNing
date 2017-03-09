

//
//  XNContactListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNContactListController.h"
#import "XNMessageListController.h"
#import "XNDatabaseService.h"
#import "XNContactModel.h"
#import <MJExtension.h>


@interface XNContactListController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XNContactListController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = [XNHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    [self.dataArray removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [XNDatabaseService eachAllContactsData:^(NSDictionary *dict) {
        XNLog(@"%@", dict);
        XNContactModel *model = [XNContactModel mj_objectWithKeyValues:dict];
        [weakSelf.dataArray addObject:model];
    } done:^{
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
    }];
}

- (void)endRefresh {
    // 刷新表格
    [self.tableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无消息" withRowCount:self.dataArray.count];
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"contactList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    XNContactModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark - 消息列表

- (IBAction)messageBtnClick {
    XNMessageListController *messageListVC = [[XNMessageListController alloc] init];
    messageListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageListVC animated:YES];
}


@end
