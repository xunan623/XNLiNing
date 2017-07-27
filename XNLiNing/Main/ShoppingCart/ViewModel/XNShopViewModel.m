//
//  XNShopViewModel.m
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopViewModel.h"
#import "XNShopCartModel.h"
#import "XNCommodityModel.h"
#import <MJExtension.h>

@implementation XNShopViewModel

- (void)getShopData:(void (^)(NSArray *, NSArray *))shopDataBlock priceBlock:(void (^)())priceBlock {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShopData" ofType:@"plist"];
    NSMutableDictionary *strategyDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *commonList = strategyDic[@"common"];
    NSArray *kuList = strategyDic[@"kuajing"];
    
    NSMutableArray *commonMuList = [NSMutableArray array];
    NSMutableArray *kuMuList = [NSMutableArray array];
    
    for (NSInteger i = 0; i < commonList.count; i++) {
        XNShopCartModel *model = [XNShopCartModel mj_objectWithKeyValues:commonList[i]];
        model.vm = self;
        model.type = 1;
        model.isSelect= YES;
        [commonMuList addObject:model];
    }
    
    for (NSInteger i = 0; i< kuList.count; i++) {
        XNShopCartModel *model = [XNShopCartModel mj_objectWithKeyValues:kuList[i]];
        model.vm = self;
        model.type = 2;
        model.isSelect = YES;
        [kuMuList addObject:model];
    }
    
    // 如果有数据了 为什么还要添加呢???
    if (commonMuList.count) {
        [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
    }
    
    if (kuMuList.count) {
        [kuMuList addObject:[self verificationSelect:kuMuList type:@"2"]];
    }
    
    _priceBlock = priceBlock;
    shopDataBlock(commonMuList, kuMuList);
    
}

- (void)getNumPrices:(void (^)())priceBlock {
    _priceBlock = priceBlock;
}

- (void)clickAllButton:(NSMutableArray *)carDataArrList button:(UIButton *)bt {
    
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        for (int j=0; j<dataList.count-1; j++) {
            XNShopCartModel *model = (XNShopCartModel *)[dataList objectAtIndex:j];
            if (model.type==1 && bt.tag==100) {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
                
            }
            else if(model.type==2 &&bt.tag==101)
            {
                if (bt.selected) {
                    [dic setObject:@"YES" forKey:@"checked"];
                }
                else
                {
                    [dic setObject:@"NO" forKey:@"checked"];
                }
                if ([model.item_info.sale_state isEqualToString:@"3"]) {
                    continue;
                }
                else{
                    model.isSelect=bt.selected;
                }
            }
        }
    }
}

- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"checked"] = @"YES";
    dict[@"type"] = type;
    for (NSInteger i = 0; i < arr.count; i++) {
        XNShopCartModel *model = arr[i];
        if (!model.isSelect) {
            dict[@"checked"] = @"NO";
            break;
        }
    }
    return dict;
}

- (void)pitchOn:(NSMutableArray *)carDataArrList {
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        [dic setObject:@"YES" forKey:@"checked"];
        for (int j=0; j<dataList.count-1; j++) {
            XNShopCartModel *model = (XNShopCartModel *)[dataList objectAtIndex:j];
            if (model.type==1 ) {
                if (!model.isSelect && ![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
                
            }
            else if(model.type==2 )
            {
                
                if (!model.isSelect &&![model.item_info.sale_state isEqualToString:@"3"]) {
                    [dic setObject:@"NO" forKey:@"checked"];
                    break;
                }
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"开始计算价钱");
    if ([keyPath isEqualToString:@"isSelect"]) {
        if (_priceBlock!=nil) {
            _priceBlock();
        }
        
    }
}

@end
