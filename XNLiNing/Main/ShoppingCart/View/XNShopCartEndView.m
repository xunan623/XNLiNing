//
//  XNShopCartEndView.m
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopCartEndView.h"

@interface XNShopCartEndView()



@end

@implementation XNShopCartEndView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isEdit"]) {
        
        if (self.isEdit) {
            self.priceLabel.hidden=YES;
            self.deleteBtn.hidden=NO;
            self.pushBtn.hidden=YES;
        }
        else
        {
            self.priceLabel.hidden=NO;
            self.deleteBtn.hidden=YES;
            self.pushBtn.hidden=NO;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isEdit"];
}


#pragma mark - Action

- (IBAction)clickAllEnd:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickALLEnd:)]) {
        [self.delegate clickALLEnd:sender];
    }
}

- (IBAction)clickRightBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickRightBT:)]) {
        [self.delegate clickRightBT:sender];
    }
    
}

- (IBAction)clickDeleteBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickALLEnd:)]) {
        [self.delegate clickALLEnd:sender];
    }
}

#pragma mark - Setting & Getting 

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
}


@end
