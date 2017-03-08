//
//  XNFrashLayer.h
//  XNLiNing
//
//  Created by xunan on 2017/3/8.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface XNFrashLayer : CALayer

@property (nonatomic, assign) CGFloat complete;

@property (nonatomic, assign) CGFloat animationScale;

/** 开始动画 开始刷新时调用 */
- (void)beginAnimation;

/** 结束动画 */
- (void)stopAnimation;

@end
