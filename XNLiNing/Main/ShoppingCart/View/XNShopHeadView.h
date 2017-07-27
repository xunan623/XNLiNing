//
//  XNShopHeadView.h
//  XNLiNing
//
//  Created by xunan on 2017/7/26.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XNShopHeadViewClickBlock)(UIButton *);

@interface XNShopHeadView : UIView

@property (copy, nonatomic) XNShopHeadViewClickBlock clickBlock;

- (void)setupData:(NSMutableArray *)dataArray index:(NSInteger)index block:(void(^)(UIButton *btn))block;

@end
