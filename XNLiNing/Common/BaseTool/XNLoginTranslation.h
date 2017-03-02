//
//  XNLoginTranslation.h
//  XNLiNing
//
//  Created by xunan on 2017/3/2.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XNLoginTranslation : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL reverse;

- (instancetype)initWithView:(UIView *)btnView;
- (void)stopAnimation;

@end
