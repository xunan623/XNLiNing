

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
#import "ChineseToPinyin.h"


@interface XNContactListController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@end

@implementation XNContactListController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    

}

- (void)setupTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.mj_header = [XNHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.rowHeight = 50;
}

- (void)loadNewData {
    [self.dataSource removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *contactsSource = [NSMutableArray array];
    [XNDatabaseService eachAllContactsData:^(NSDictionary *dict) {
        XNLog(@"%@", dict);
        XNContactModel *model = [XNContactModel mj_objectWithKeyValues:dict];
        [contactsSource addObject:model];
    } done:^{
        [weakSelf.dataSource addObjectsFromArray:[weakSelf sortDataArray:contactsSource]];

        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count] +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    [tableView tableViewDisplayWithMsg:@"暂无消息" withRowCount:self.dataSource.count];
    return [[self.dataSource objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [[UITableViewCell alloc] init];
    }
    static NSString *cellName = @"contactList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    XNContactModel *model = [[self.dataSource objectAtIndex:(indexPath.section -1)] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}
/**
 *  section头部视图的View   组的头部
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 || [[self.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = XNColor_RGB(239, 239, 239);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

/**
 *  索引
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    
    return existTitles;
}


/**
 *  索引核心
 */
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection-1];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (XNContactModel *buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.name.length ? buddy.name : @"哈哈"];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(XNContactModel *obj1, XNContactModel *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.name];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.name];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - 消息列表

- (IBAction)messageBtnClick {
    XNMessageListController *messageListVC = [[XNMessageListController alloc] init];
    messageListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageListVC animated:YES];
}


@end
