//
//  XNSettingHeaderView.h
//  XNLiNing
//
//  Created by xunan on 2017/3/7.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNSettingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageBGView;

+ (instancetype)msGetInstance;

@end
