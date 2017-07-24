//
//  XNClassCategoryCell.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNClassCategoryCell.h"
#import "XNClassGoodsItem.h"
#import <Masonry.h>

@interface XNClassCategoryCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *indicatorView;

@end

@implementation XNClassCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setupUI {

    [self addSubview:self.titleLabel];
    
    [self addSubview:self.indicatorView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(5);
    }];
}

#pragma mark - cell点击
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _indicatorView.hidden = NO;
        self.titleLabel.textColor = [UIColor redColor];
        self.backgroundColor = [UIColor whiteColor];
    }else{
        _indicatorView.hidden = YES;
        self.titleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setTitleItem:(XNClassGoodsItem *)titleItem {
    _titleItem = titleItem;
    self.titleLabel.text = titleItem.title;
}

#pragma mark - Setting & Getting 

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.hidden = NO;
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

@end
