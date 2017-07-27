//
//  XNChangeCountView.m
//  XNLiNing
//
//  Created by xunan on 2017/7/26.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNChangeCountView.h"

@interface XNChangeCountView()



@end

@implementation XNChangeCountView

- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.choosedCount = chooseCount;
        self.totalCount = totalCount;
        [self setUpViews];
    }
    return self;
}

- (void)setupChooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount {
    self.choosedCount = chooseCount;
    self.totalCount = totalCount;
    [self setUpViews];
}

- (void)setUpViews
{
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, [UIImage imageNamed:@"product_detail_sub_normal"].size.width, [UIImage imageNamed:@"product_detail_sub_normal"].size.height);
    
    
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
    
    _subButton.exclusiveTouch = YES;
    [self addSubview:_subButton];
    if (self.choosedCount <= 1) {
        _subButton.enabled = NO;
    }else{
        _subButton.enabled = YES;
    }
    _numberFD = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_subButton.frame), 0, 40, _subButton.frame.size.height)];
    
    
    _subButton.backgroundColor=[UIColor clearColor];
    _numberFD.textAlignment=NSTextAlignmentCenter;
    _numberFD.keyboardType=UIKeyboardTypeNumberPad;
    _numberFD.clipsToBounds = YES;
    _numberFD.layer.borderColor = [XNColor_Hex(0xdddddd) CGColor];
    _numberFD.layer.borderWidth = 0.5;
    _numberFD.textColor = XNColor_Hex(0x333333);
    
    _numberFD.font=[UIFont systemFontOfSize:13];
    _numberFD.backgroundColor = [UIColor whiteColor];
    _numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    
    [self addSubview:_numberFD];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberFD.frame), 0, [UIImage imageNamed:@"product_detail_sub_normal"].size.width, [UIImage imageNamed:@"product_detail_sub_normal"].size.height);
    _addButton.backgroundColor=[UIColor clearColor];
    
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
    
    _addButton.exclusiveTouch = YES;
    [self addSubview:_addButton];
    if (self.choosedCount >= self.totalCount) {
        _addButton.enabled = NO;
    }else{
        _addButton.enabled = YES;
    }
}



@end
