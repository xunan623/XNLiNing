//
//  XNBrandSortCell.m
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBrandSortCell.h"
#import "XNClassSubItem.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface XNBrandSortCell()

@property (strong, nonatomic) UIImageView *brandImageView;

@end

@implementation XNBrandSortCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.brandImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.rw_width - 20, self.rw_height - 25));
    }];
}



#pragma mark - Setting & Getting 

- (UIImageView *)brandImageView {
    if (!_brandImageView) {
        _brandImageView = [[UIImageView alloc] init];
        _brandImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _brandImageView;
}

- (void)setSubItem:(XNClassSubItem *)subItem {
    _subItem = subItem;
    
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:subItem.image_url]];
}

@end
