//
//  XNCommodityModel.h
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNCommodityModel : NSObject

@property(nonatomic,copy)NSString *commission;
@property(nonatomic,copy)NSString *discount_rate;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *item_id;
@property(nonatomic,copy)NSString *item_state;
@property(nonatomic,copy)NSString *market_price;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *name_add;
@property(nonatomic,copy)NSString *resell_item_sale_state;
@property(nonatomic,copy)NSString *resell_item_state;
@property(nonatomic,copy)NSString *sale_price;
@property(nonatomic,copy)NSString *sale_state;
@property(nonatomic,copy)NSString *shop_item_state;
@property(nonatomic,copy)NSString *shop_item_sale_state;
@property(nonatomic,copy)NSString *full_name;
@property(nonatomic,copy)NSString *miya_point;
@property(nonatomic,copy)NSString *relate_flag;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *origin;
@property(nonatomic,copy)NSString *desc_text;
@property(nonatomic,copy)NSString *brand_name;
@property(nonatomic,copy)NSString *cate_name;
@property(nonatomic,copy)NSArray *pic;
@property(nonatomic,copy)NSString *share_url;
@property(nonatomic,copy)NSArray *normal;
@property (nonatomic,copy) NSMutableArray *relation_items;
@property (nonatomic, copy) NSArray *spu_list;
@property (nonatomic, copy) NSArray *spu_items;

@property(nonatomic,strong)NSArray *detail;

@property (nonatomic, strong) NSString *isSelect;


@property(nonatomic,copy) NSString *rec_state;

@property(nonatomic,copy)NSString *stock_quantity;
@property(nonatomic,assign)NSInteger type;



@property(nonatomic,assign)NSInteger auth_level;

@property(nonatomic,copy)NSString *is_spu;
@property(nonatomic,copy)NSString *is_single_sale;


@property(nonatomic,strong)NSArray *topicArry;


@end
