//
//  XNShopHeadView.m
//  XNLiNing
//
//  Created by xunan on 2017/7/26.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopHeadView.h"

@interface XNShopHeadView()

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (copy, nonatomic) NSMutableArray *dataArray;

@end

@implementation XNShopHeadView

#pragma mark - Action

- (IBAction)clickAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.clickBlock) self.clickBlock(sender);
}

#pragma mark - Setting & Getting 

- (void)setupData:(NSMutableArray *)dataArray index:(NSInteger)index block:(void (^)(UIButton *))block {
    self.dataArray = dataArray;
    _clickBlock = block;
    
    self.checkBtn.tag = index * 100;
    
    NSMutableDictionary *dic  = [self.dataArray[index] lastObject];
    
    if ([dic[@"checked"] isEqualToString:@"YES"]) {
        self.checkBtn.selected = YES;
    }
    else if ([dic[@"checked"] isEqualToString:@"NO"]) {
        self.checkBtn.selected = NO;
    }
    
    NSInteger dicType = [dic[@"type"] integerValue];
    
    switch (dicType) {
        case 1: {
            self.firstLabel.text=@"商品标题1";
        }
            break;
        case 2: {
            self.firstLabel.text=@"商品标题2";
        }
            break;
        default:
            break;
    }
}

@end
