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

        self.titleImage.frame = CGRectMake(XNScreen_Width / 4 * 0.5 - 25 , XNScreen_Width / 4 * 0.5 - 25, 50, 50);
        self.titleImage.contentMode = UIViewContentModeScaleAspectFit;
        self.titleImage.image = [UIImage imageNamed:@"img-login-logo"];
        [self addSubview:self.titleImage];
    }
    return self;
}
@end
