//
//  XNBrandsSortHeadView.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBrandsSortHeadView.h"
#import "XNClassMainItem.h"


@interface XNBrandsSortHeadView()

@property (strong , nonatomic)UILabel *headLabel;


@end

@implementation XNBrandsSortHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
#pragma mark - UI
- (void)setUpUI
{
    _headLabel = [[UILabel alloc] init];
    _headLabel.font = [UIFont systemFontOfSize:13];
    _headLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_headLabel];
    
    _headLabel.frame = CGRectMake(XNAPPMargin, 0, self.rw_width, self.rw_height);
}

#pragma mark - Setter Getter Methods
- (void)setHeadTitle:(XNClassMainItem *)headTitle
{
    _headTitle = headTitle;
    _headLabel.text = headTitle.title;
}


@end
