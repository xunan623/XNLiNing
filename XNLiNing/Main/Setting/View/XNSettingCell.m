//
//  XNSettingCell.m
//  XNLiNing
//
//  Created by xunan on 2017/3/7.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSettingCell.h"

@implementation XNSettingCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 这里需要初始化ImageView；
        self.titleImage = [[UIImageView alloc] init];

        self.titleImage.frame = CGRectMake(XNScreen_Width / 4 * 0.5 - 20 , XNScreen_Width / 4 * 0.5 - 35, 40, 40);
        self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
        self.titleImage.image = [UIImage imageNamed:@"img-login-logo"];
        [self addSubview:self.titleImage];
        
        self.tittleLabels = [[UILabel alloc] init];
        self.tittleLabels.frame = CGRectMake(XNScreen_Width / 4 * 0.5 - 50, XNScreen_Width / 4 * 0.5 + 15, 100, 20);
        self.tittleLabels.textAlignment = NSTextAlignmentCenter;
        self.tittleLabels.font = [UIFont systemFontOfSize:12.f];
        self.tittleLabels.textColor = XNColor_RGB(50, 50, 50);
        [self addSubview:self.tittleLabels];
    }
    return self;
}



@end
