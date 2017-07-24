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
#import "XNClassGoodsItem.h"
#import "XNClassMainItem.h"
#import <MJExtension.h>
#import "XNClassCategoryCell.h"
#import "XNBrandSortCell.h"
#import "XNGoodsSortCell.h"
#import "XNBrandsSortHeadView.h"

@interface XNTaskController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UITableView *tableView;
@property (strong , nonatomic)UICollectionView *collectionView;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger pageSize;

/* 左边数据 */
@property (strong , nonatomic)NSArray<XNClassGoodsItem *> *titleItem;
/* 右边数据 */
@property (strong , nonatomic)NSArray<XNClassMainItem *> *mainItem;


@end

static CGFloat TableViewW = 100.0f;
static NSString *XNClassCategoryCellId = @"XNClassCategoryCell";
static NSString *XNGoodsSortCellId = @"XNGoodsSortCell";
static NSString *XNBrandSortCellId = @"XNBrandSortCell";
static NSString *XNBrandsSortHeadViewId = @"XNBrandsSortHeadView";

@implementation XNTaskController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XNHeight_TopBar, TableViewW, XNScreen_Height - XNHeight_TopBar - XNHeight_TabBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50.0f;
        _tableView.dataSource = self;
        [_tableView registerClass:[XNClassCategoryCell class] forCellReuseIdentifier:XNClassCategoryCellId];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TableViewW, XNHeight_TopBar, XNScreen_Width - TableViewW, XNScreen_Height - XNHeight_TopBar - XNHeight_TabBar) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = XNAPPNormalBGColor;
        _collectionView.delegate = self;
        [_collectionView registerClass:[XNBrandSortCell class] forCellWithReuseIdentifier:XNBrandSortCellId];
        [_collectionView registerClass:[XNGoodsSortCell class] forCellWithReuseIdentifier:XNGoodsSortCellId];
        [_collectionView registerClass:[XNBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:XNBrandsSortHeadViewId];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self setupData];
}

- (void)setupData {
    self.titleItem = [XNClassGoodsItem mj_objectArrayWithFilename:@"ClassifyTitles.plist"];
    self.mainItem = [XNClassMainItem mj_objectArrayWithFilename:@"ClassiftyGoods01.plist"];
    //默认选择第一行（注意一定要在加载完数据之后）
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" withRowCount:self.titleItem.count];
    return self.titleItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XNClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:XNClassCategoryCellId forIndexPath:indexPath];
    cell.titleItem = self.titleItem[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];  取消所有cell的选中 慎用
    self.mainItem = [XNClassMainItem mj_objectArrayWithFilename:self.titleItem[indexPath.row].fileName];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mainItem.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mainItem[section].goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *baseCell = nil;
    if ([self.mainItem[self.mainItem.count -1].title isEqualToString:@"热门品牌"]) {
        if (indexPath.section == self.mainItem.count - 1) { // 品牌
            XNBrandSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XNBrandSortCellId forIndexPath:indexPath];
            cell.subItem = self.mainItem[indexPath.section].goods[indexPath.row];
            baseCell = cell;
        } else {
            XNGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XNGoodsSortCellId forIndexPath:indexPath];
            cell.subItem = self.mainItem[indexPath.section].goods[indexPath.row];
            baseCell = cell;
        }
    } else {
        XNGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XNGoodsSortCellId forIndexPath:indexPath];
        cell.subItem = self.mainItem[indexPath.section].goods[indexPath.row];
        baseCell = cell;
    }
    return baseCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        XNBrandsSortHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XNBrandsSortHeadViewId forIndexPath:indexPath];
        headerView.headTitle = self.mainItem[indexPath.section];
        reusableView = headerView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.mainItem[self.mainItem.count -1].title isEqualToString:@"热门品牌"]) {
        if (indexPath.section == self.mainItem.count -1) {
            return CGSizeMake((XNScreen_Width - TableViewW - 6)/3, 60);
        } else {
            return CGSizeMake((XNScreen_Width - TableViewW - 6)/3, (XNScreen_Width - TableViewW - 6)/3 + 20);
        }
    } else {
        return CGSizeMake((XNScreen_Width - TableViewW - 6)/3, (XNScreen_Width - TableViewW- 6)/3 +20);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(XNScreen_Width, 25);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了个第%zd分组第%zd几个Item",indexPath.section,indexPath.row);
}






/*
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
 
 */

@end
