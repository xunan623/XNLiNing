//
//  XNHeaderView.m
//  XNLiNing
//
//  Created by xunan on 2017/3/8.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNHeaderView.h"
#import "XNFrashLayer.h"

@interface XNHeaderView()

@property (nonatomic, strong) XNFrashLayer *freshLayer;

@end

@implementation XNHeaderView

#pragma mark - 重写方法
- (void)prepare {
    [super prepare];
    self.mj_h = 80;
}

- (void)dealloc {
    [self.freshLayer stopAnimation];
}

#pragma mark - 设置子控件位置和尺寸

-(void)placeSubviews {
    [super placeSubviews];
    if (!self.freshLayer) {
        self.freshLayer = [XNFrashLayer layer];
        _freshLayer.frame = self.bounds;
        _freshLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_freshLayer];
    }
}

#pragma mark - 监听scrollView的contentSize改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mrk - 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark - 监听控件刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.freshLayer stopAnimation];
        }
            break;
        case MJRefreshStatePulling:
        {
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self.freshLayer beginAnimation];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 监听拖拽比例
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    //这里 pullingPercent == 1.0 时 会出错 (备注已经解决)
//    self.mj_y = -self.mj_h * MIN(1.125, MAX(0.0, pullingPercent)); //动手修改一下试试
    self.mj_y = -self.mj_h * MIN(1.0, MAX(0.0, pullingPercent));
    CGFloat complete = MIN(1.0, MAX(0.0, pullingPercent-0.125));
    self.freshLayer.complete = complete;
}

@end
