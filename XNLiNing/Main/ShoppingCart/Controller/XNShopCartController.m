//
//  XNShopCartController.m
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopCartController.h"
#import "XNShopCartEndView.h"
#import "XNShopCartModel.h"
#import "XNShopViewModel.h"
#import "XNShopCartCell.h"
#import "XNShopHeadView.h"
#import "XNCommodityModel.h"

@interface XNShopCartController ()<UITableViewDelegate, UITableViewDataSource, XNShopCartEndViewDelegate, XNShopCartCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataListArray;
@property (strong, nonatomic) XNShopCartEndView *endView;
@property (strong, nonatomic) XNShopViewModel *vm;
@property(nonatomic,assign)BOOL isEdit;

@end

static CGFloat EndViewH = 44.0f;
static CGFloat ShopCellH = 100.0f;


@implementation XNShopCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    [self loadData];
}

- (void)setupUI {
    [self setNavTitle:@"购物车"];
    
    __weak typeof(self) weakSelf = self;
    [self.navBar setRight:nil title:@"编辑" block:^(UIButton *btn) {
        weakSelf.isEdit = !weakSelf.isEdit;
        if (weakSelf.isEdit) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            for (int i=0; i< weakSelf.dataListArray.count; i++) {
                NSArray *list = [weakSelf.dataListArray objectAtIndex:i];
                for (int j = 0; j<list.count-1; j++) {
                    XNShopCartModel *model = [list objectAtIndex:j];
                    model.isSelect= ![model.item_info.sale_state isEqualToString:@"3"];
                }
            }
        }
        else{
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            for (int i=0; i<weakSelf.dataListArray.count; i++) {
                NSArray *list = [weakSelf.dataListArray objectAtIndex:i];
                for (int j = 0; j<list.count-1; j++) {
                    XNShopCartModel *model = [list objectAtIndex:j];
                    model.isSelect = YES;
                }
            }
        }
        
        weakSelf.endView.isEdit = weakSelf.isEdit;
        [weakSelf.vm pitchOn:weakSelf.dataListArray];
        [weakSelf.tableView reloadData];
        
    }];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.endView];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    _vm = [[XNShopViewModel alloc] init];
    [_vm getShopData:^(NSArray *commonArray, NSArray *kuArray) {
        [weakSelf.dataListArray addObject:commonArray];
        [weakSelf.dataListArray addObject:kuArray];
        [weakSelf.tableView reloadData];
        [weakSelf numPrice];
    } priceBlock:^{
        [weakSelf numPrice];
    }];
}

- (void)numPrice
{
    NSArray *lists =   [_endView.priceLabel.text componentsSeparatedByString:@"￥"];
    float num = 0.00;
    for (int i=0; i<self.dataListArray.count; i++) {
        NSArray *list = [self.dataListArray objectAtIndex:i];
        for (int j = 0; j<list.count-1; j++) {
            XNShopCartModel *model = [list objectAtIndex:j];
            NSInteger count = [model.count integerValue];
            float sale = [model.item_info.sale_price floatValue];
            if (model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"] ) {
                num = count*sale+ num;
            }
        }
    }
    _endView.priceLabel.text = [NSString stringWithFormat:@"%@￥%.2f",lists[0],num];
}


#pragma mark - Setting & Getting 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XNHeight_TopBar,
                                                                   XNScreen_Width,
                                                                   XNScreen_Height - XNHeight_TopBar - XNHeight_TabBar - EndViewH)
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = ShopCellH;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XNShopCartCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([XNShopCartCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
}

- (XNShopCartEndView *)endView {
    if (!_endView) {
        _endView = [XNShopCartEndView rw_viewFromXib];
        _endView.frame = CGRectMake(0,
                                    XNScreen_Height - XNHeight_TabBar - EndViewH,
                                    XNScreen_Width,
                                    EndViewH);
        _endView.delegate = self;
        _endView.isEdit = self.isEdit;
    }
    return _endView;
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.dataListArray[section] count] -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 50 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10.0f : 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak typeof(self) weakSelf = self;
    XNShopHeadView *headerView = [XNShopHeadView rw_viewFromXib];
    headerView.frame = CGRectMake(0, 0, XNScreen_Width, 40);
    [headerView setupData:self.dataListArray index:section block:^(UIButton *btn) {
        [weakSelf.vm clickAllButton:weakSelf.dataListArray button:btn];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag/100];
        [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XNShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XNShopCartCell class])
                                                           forIndexPath:indexPath];
    cell.isEdit = self.isEdit;
    NSArray *list = [self.dataListArray objectAtIndex:indexPath.section];
    cell.row = indexPath.row + 1;
    [cell setModel:[list objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSMutableArray *list = [self.dataListArray objectAtIndex:indexPath.section];

        XNShopCartModel *model = [ list objectAtIndex:indexPath.row];
        model.isSelect=NO;
        [list removeObjectAtIndex:indexPath.row];
        
        if (list.count==1) [self.dataListArray removeObjectAtIndex:indexPath.section];
        
        [_tableView reloadData];
        
    }
}
#pragma mark - XNShopCartEndViewDelegate

- (void)clickRightBT:(UIButton *)bt {
    
    if(bt.tag==19)
    {
        //删除
        for (int i = 0; i<self.dataListArray.count; i++) {
            NSMutableArray *arry = [self.dataListArray objectAtIndex:i];
            for (int j=0 ; j<arry.count-1; j++) {
                XNShopCartModel *model = [ arry objectAtIndex:j];
                if (model.isSelect==YES) {
                    [arry removeObjectAtIndex:j];
                    continue;
                }
            }
            if (arry.count<=1) {
                [self.dataListArray removeObjectAtIndex:i];
            }
        }
        [self.tableView reloadData];
    }
    else if (bt.tag==18)
    {
        //结算
        
    }
    
}

- (void)clickALLEnd:(UIButton *)bt {
    bt.selected = !bt.selected;
    
    BOOL btselected = bt.selected;
    
    NSString *checked = @"";
    if (btselected) {
        checked = @"YES";
    }
    else
    {
        checked = @"NO";
    }
    
    if (self.isEdit) {
        //取消
        for (int i =0; i<self.dataListArray.count; i++) {
            NSArray *dataList = [self.dataListArray objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            
            [dic setObject:checked forKey:@"checked"];
            for (int j=0; j<dataList.count-1; j++) {
                XNShopCartModel *model = (XNShopCartModel *)[dataList objectAtIndex:j];
                if (![model.item_info.sale_state isEqualToString:@"3"]) {
                    model.isSelect=btselected;
                }
                
            }
        }
    }
    else
    {
        //编辑
        for (int i =0; i<self.dataListArray.count; i++) {
            NSArray *dataList = [self.dataListArray objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            for (int j=0; j<dataList.count-1; j++) {
                XNShopCartModel *model = (XNShopCartModel *)[dataList objectAtIndex:j];
                model.isSelect=btselected;
            }
        }
        
    }
    
    [_tableView reloadData];

}

#pragma mark - XNShopCartCellDelegate

- (void)singleClick:(XNShopCartModel *)models row:(NSInteger)row {
    [_vm pitchOn:self.dataListArray];
    if (models.type==1) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    else if(models.type==2 ) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}


@end
