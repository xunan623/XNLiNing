//
//  XNGoodsSortCell.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNGoodsSortCell.h"
#import "XNClassMainItem.h"
#import "XNClassSubItem.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface XNGoodsSortCell()

@property (strong , nonatomic)UIImageView *goodsImageView;

@property (strong , nonatomic)UILabel *goodsTitleLabel;

@end

@implementation XNGoodsSortCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.goodsImageView];
    [self addSubview:self.goodsTitleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:5];
        make.size.mas_equalTo(CGSizeMake(self.rw_width *0.85, self.rw_width * 0.85));
    }];
    
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.goodsImageView.mas_bottom)setOffset:5];
        make.width.mas_equalTo(self.goodsImageView);
        make.centerX.mas_equalTo(self);
    }];
}


#pragma mark - Setting & Getting 

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodsImageView;
}

- (UILabel *)goodsTitleLabel {
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] init];
        _goodsTitleLabel.font = [UIFont systemFontOfSize:13];
        _goodsTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodsTitleLabel;
}

- (void)setSubItem:(XNClassSubItem *)subItem {
    _subItem = subItem;
    
    _subItem = subItem;
    if ([subItem.image_url containsString:@"http"]) {
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:subItem.image_url]];
    }else{
        _goodsImageView.image = [UIImage imageNamed:subItem.image_url];
    }
    _goodsTitleLabel.text = subItem.goods_title;

}

@end
