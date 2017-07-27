//
//  XNShopCartModel.h
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNCommodityModel, XNShopViewModel;

@interface XNShopCartModel : NSObject

@property(nonatomic,copy)NSString *item_id;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *item_size;
@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)XNCommodityModel *item_info;

@property(nonatomic,weak)XNShopViewModel *vm;

@end
