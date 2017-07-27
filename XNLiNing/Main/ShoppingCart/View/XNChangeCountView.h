//
//  XNChangeCountView.h
//  XNLiNing
//
//  Created by xunan on 2017/7/26.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNChangeCountView : UIView

//加
@property (nonatomic, strong) UIButton *addButton;
//减
@property (nonatomic, strong) UIButton *subButton;
//数字按钮
@property (nonatomic, strong) UITextField  *numberFD;

//已选数
@property (nonatomic, assign) NSInteger choosedCount;

//总数
@property (nonatomic, assign) NSInteger totalCount;

- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount;

- (void)setupChooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount;

@end
