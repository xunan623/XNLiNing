//
//  XNShopCartEndView.h
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XNShopCartEndViewDelegate <NSObject>

-(void)clickALLEnd:(UIButton *)btn;

-(void)clickRightBT:(UIButton *)btn;


@end

@interface XNShopCartEndView : UIView

@property (weak, nonatomic) id <XNShopCartEndViewDelegate> delegate;
@property (assign, nonatomic) BOOL isEdit;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
