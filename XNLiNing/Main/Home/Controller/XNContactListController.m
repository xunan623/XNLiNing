

//
//  XNContactListController.m
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNContactListController.h"
#import "XNDatabaseService.h"
#import "XNContactModel.h"
#import <MJExtension.h>
#import "ChineseToPinyin.h"
#import "XNContactCell.h"
#import <RongIMKit/RongIMKit.h>



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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    item.badgeValue= @"2";

}

- (void)setupNav {
    self.navigationItem.title = @"联系人";
}

- (void)setupTableView {
    
    self.tableView.backgroundColor = XNAPPNormalBGColor;
    self.tableView.mj_header = [XNHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNContactCell class])
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:NSStringFromClass([XNContactCell class])];
    // 设置索引的背景色为透明色
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    self.tableView.sectionIndexColor = XNColor_RGB(30, 30, 30);
}

- (void)loadNewData {
    [self.dataSource removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *contactsSource = [NSMutableArray array];
    [XNDatabaseService eachAllContactsData:^(NSDictionary *dict) {
        XNContactModel *model = [XNContactModel mj_objectWithKeyValues:dict];
        [contactsSource addObject:model];
    } done:^{
        [weakSelf.dataSource addObjectsFromArray:[weakSelf sortDataArray:contactsSource]];

        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/**
 * 排序
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
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [tableView tableViewDisplayWithMsg:@"暂无消息" withRowCount:self.dataSource.count];
    return [[self.dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XNContactCell *cell = [XNContactCell msGetInstance];
    XNContactModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[self.dataSource objectAtIndex:section] count]== 0) return 0;
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[self.dataSource objectAtIndex:section] count] == 0) return nil;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = XNAPPNormalBGColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = XNColor_RGB(170, 170, 170);
    label.font = [UIFont systemFontOfSize:15.0f];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XNContactModel *model = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    RCConversationViewController *chat = [[RCConversationViewController alloc]
                                          initWithConversationType:ConversationType_PRIVATE
                                                          targetId:model.id];
    //设置聊天会话界面要显示的标题
    chat.title = model.name;
    chat.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = NO;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
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

#pragma mark - 消息列表

- (IBAction)messageBtnClick {
}


@end
