//
//  XNShopViewModel.h
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NumPriceBlock)();

@interface XNShopViewModel : NSObject

@property (copy, nonatomic) NumPriceBlock priceBlock;

/** 访问网络 获取数据 block回调失败或者成功 都可以在这处理 */
- (void)getShopData:(void(^)(NSArray *commonArray, NSArray *kuArray))shopDataBlock priceBlock:(void(^)())priceBlock;

- (void)getNumPrices:(void(^)())priceBlock;

- (void)clickAllButton:(NSMutableArray *)carDataArrList button:(UIButton *)btn;

- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type;

- (void)pitchOn:(NSMutableArray *)carDataArrList;

@end
