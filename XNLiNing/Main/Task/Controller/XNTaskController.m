//
//  XNTaskController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNTaskController.h"
#import "XNAppURL.h"
#import "XNTaskModel.h"

@interface XNTaskController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger pageSize;

@end

@implementation XNTaskController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [XNHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    self.page = 1;
    NSDictionary *params = @{@"param.userId"        : [XNUserDefaults new].userName,
                             @"param.pdaNumber"     : @"",
                             @"param.roleProperty"  : @"",
                             @"param.maxPage"       : @(0),
                             @"param.updateDate"    : @"",
                             @"param.currPage"      : @(self.page)};
    __weak typeof(self) weakSelf = self;
    [XNBaseReq requestGetWithUrl:AppRequestURL_followApp
                          params:params
                 responseSucceed:^(NSDictionary *res) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        XNTaskModel *model = [[XNTaskModel alloc] initWithDictionary:res error:nil];
        if ([model.retVal boolValue]) {
            [weakSelf.dataArray addObjectsFromArray:model.list];
            [weakSelf.tableView reloadData];
        } else {
            [XNAlertView showWithTitle:model.failMessage];
        }
    } responseFailed:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [XNAlertView showWithTitle:error];

    }];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" withRowCount:self.dataArray.count];
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

















@end
