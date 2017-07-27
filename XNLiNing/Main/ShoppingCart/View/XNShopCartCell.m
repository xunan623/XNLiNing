//
//  XNShopCartCell.m
//  XNLiNing
//
//  Created by xunan on 2017/7/25.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNShopCartCell.h"
#import "XNShopCartModel.h"
#import <UIImageView+WebCache.h>
#import "XNCommodityModel.h"
#import "XNChangeCountView.h"

@interface XNShopCartCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImgView;
@property (weak, nonatomic) IBOutlet UIImageView *spuImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet XNChangeCountView *changeView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldoutLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;

@end

@implementation XNShopCartCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.shopImgView.layer.masksToBounds = YES;
    self.shopImgView.layer.cornerRadius = 2;
    self.shopImgView.layer.borderWidth = 1;
    self.shopImgView.layer.borderColor = XNColor_Hex(0xe2e2e2).CGColor;
    
    
}


#pragma mark - Setting & Getting 

- (void)setModel:(XNShopCartModel *)model {
    _model = model;
    
    self.selectBtn.selected = model.isSelect;
    
    self.choosedCount  = self.changeView.numberFD.text ? [_changeView.numberFD.text integerValue] : [model.count integerValue];
    
    [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:model.item_info.icon] placeholderImage:[UIImage imageNamed:@"default"]];
    
    if ([model.item_info.is_spu intValue] == 1) {
        UIImage *img = [UIImage imageNamed:@"spuIcon"];
        _spuImgView.image = img;
        self.priceLabel.text=[NSString stringWithFormat:@"套装价￥%@",model.item_info.sale_price];
    } else {
        UIImage *level = [UIImage imageNamed:@"level2"];
        if (model.item_info.type == 5) {
            _spuImgView.image = [UIImage imageNamed:@"level3"];
        } else if (model.item_info.type == 6) {
            self.spuImgView.image = level;
        }
        if (![model.item_size isEqualToString:@"SINGLE"]) {
            self.sizeLab.text = [NSString stringWithFormat:@"规格:%@",model.item_size];
        }
        self.priceLabel.text=[NSString stringWithFormat:@"￥%@",model.item_info.sale_price];
    }
    
    self.titleLabel.text= model.item_info.full_name;
    
    
    if ([model.item_info.sale_state isEqualToString:@"3"]) {
        self.soldoutLab.hidden=NO;
        self.selectBtn.enabled=NO;
        
        if (self.isEdit) {
            //编辑状态
            self.selectBtn.enabled=YES;
        }
    }
    else{
        
        self.soldoutLab.hidden = YES;
        
        self.selectBtn.enabled=YES;
        
        [self.changeView setupChooseCount:self.choosedCount totalCount:[model.item_info.stock_quantity integerValue]];
        
        [self.changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.changeView.numberFD.delegate = self;
        
        [self.changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.changeView.hidden = !self.soldoutLab.hidden;
}

//加
- (void)addButtonPressed:(id)sender
{
    
    if (self.choosedCount<99) {
        
    }
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if ([_model.item_info.stock_quantity integerValue]<self.choosedCount) {
        self.choosedCount  = [_model.item_info.stock_quantity  intValue];
        _changeView.addButton.enabled = NO;
    }
    else
    {
        _changeView.subButton.enabled = YES;
    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect= self.selectBtn.selected;
    
}

//减
- (void)subButtonPressed:(id)sender
{
    
    if (self.choosedCount >1) {
    }
    
    -- self.choosedCount ;
    
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    _model.count = _changeView.numberFD.text;
    
    _model.isSelect=self.selectBtn.selected;
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text=@"1";
        }
    }
    else
    {
        _changeView.numberFD.text=@"1";
    }
    
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text=@"1";
        
    }
    NSString *numText = _changeView.numberFD.text;
    if ([numText intValue]>[_model.item_info.stock_quantity  intValue]) {
        _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",[_model.item_info.stock_quantity  intValue]];
        
        
    }
    
    if ([numText intValue] >99) {
        _changeView.numberFD.text = @"99";
    }
    
    _changeView.addButton.enabled=YES;
    _changeView.subButton.enabled=YES;
    self.choosedCount = [_changeView.numberFD.text integerValue];
    _model.count = _changeView.numberFD.text;
    _model.isSelect = self.selectBtn.selected;
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (IBAction)checkClick:(UIButton *)bt {
    if (!_soldoutLab.hidden && !self.isEdit) {
        return;
    }
    self.selectBtn.selected = !self.selectBtn.selected;
    _model.isSelect = self.selectBtn.selected;
    
    if (_changeView.numberFD.text!=nil) {
        _model.count = _changeView.numberFD.text;
    }
    
    if ([self.delegate respondsToSelector:@selector(singleClick:row:)]) {
        [self.delegate singleClick:_model row:self.row];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
