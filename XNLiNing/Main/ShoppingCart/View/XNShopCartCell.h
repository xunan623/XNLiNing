//
//  XNShopCartCell.h
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XNShopCartModel;

@protocol XNShopCartCellDelegate <NSObject>

-(void)singleClick:(XNShopCartModel *)models row:(NSInteger )row;

@end

@interface XNShopCartCell : UITableViewCell

@property(nonatomic, strong) XNShopCartModel *model;

@property(nonatomic, assign) NSInteger choosedCount;
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL isEdit;

@property(nonatomic, weak) id <XNShopCartCellDelegate> delegate;


@end
