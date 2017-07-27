//
//  XNBaseNavigationBar.h
//  XNLiNing
//
//  Created by xunan on 2017/3/13.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNBaseNavigationBar : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *rightButton;

- (void)setBackButtonHidden:(BOOL)hidden;

- (void)setRight:(NSString *)img title:(NSString *)title block:(void(^)(UIButton *))block;
@end
