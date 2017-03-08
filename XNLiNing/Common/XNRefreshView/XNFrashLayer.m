//
//  XNFrashLayer.m
//  XNLiNing
//
//  Created by xunan on 2017/3/8.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNFrashLayer.h"

static CGFloat viewHeight = 21;
static CGFloat pointWidth = 10;
static CGFloat scaleTimeValue = 0.35;

static BOOL isAnimationing;
static NSString *animationName = @"ScaleAnimationName";
static NSString *ScaleSmall = @"ScaleSmall";
static NSString *ScaleBig = @"ScaleBig";

@interface XNFrashLayer()<CAAnimationDelegate>



@end

@implementation XNFrashLayer

@dynamic animationScale;


- (void)setFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(0, 10, CGRectGetWidth(frame), viewHeight * 2);
    [super setFrame:newFrame];
}

- (void)setComplete:(CGFloat)complete {
    if (_complete != complete) {
        _complete = complete;
        [self setNeedsDisplay];
    }
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"animationScale"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)beginAnimation {
    isAnimationing = YES;
    
    [self addScaleSmallAnimation];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI * 2);
    rotate.duration = scaleTimeValue * 4;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    [self addAnimation:rotate forKey:rotate.keyPath];
}

- (void)stopAnimation {
#if 1
    if (!isAnimationing) {
        return;
    }
#endif
    isAnimationing = NO;
    [self removeAllAnimations];
    self.complete = 0.0;
    [self setNeedsDisplay];
}

#pragma mark - Private
- (void)addScaleSmallAnimation {
    self.animationScale = 0.6;
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"animationScale"];
    animation1.duration = scaleTimeValue;
    animation1.fromValue = @(1.0);
    animation1.toValue = @(0.6);
    animation1.delegate = self;
    [animation1 setValue:ScaleSmall forKey:animationName];
    [self addAnimation:animation1 forKey:@"animationScale"];
}
- (void)addScaleBigAnimation {
    self.animationScale = 1.0;
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"animationScale"];
    animation1.duration = scaleTimeValue;
    animation1.fromValue = @(0.6);
    animation1.toValue = @(1.0);
    animation1.delegate = self;
    [animation1 setValue:ScaleBig forKey:animationName];
    [self addAnimation:animation1 forKey:@"animationScale"];
}




#pragma mark - AnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:animationName] isEqualToString:ScaleSmall]) {
        if (isAnimationing) {
            [self addScaleBigAnimation];
        }
    }else if ([[anim valueForKey:animationName] isEqualToString:ScaleBig]) {
        if (isAnimationing) {
            [self addScaleSmallAnimation];
        }
    }
}


#pragma mark - 计算方法

void drawPointAtRect (CGPoint center,CGContextRef ctx, CGColorRef color) {
    CGContextSetFillColorWithColor(ctx, color);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathMoveToPoint(Path, NULL, center.x, center.y);
    CGPathAddArc(Path, NULL, center.x, center.y, pointWidth/2, (float)(2.0*M_PI), 0.0, TRUE);
    CGPathCloseSubpath(Path);
    CGContextAddPath(ctx, Path);
    CGContextFillPath(ctx);
    CGPathRelease(Path);
}
CGPoint currentProportionPoint(CGPoint starPoint, CGPoint endPoint, CGFloat scale) {
    CGFloat lengthOfX = endPoint.x - starPoint.x;
    CGFloat pointX = starPoint.x + lengthOfX * scale;
    CGFloat lengthOfY = endPoint.y - starPoint.y;
    CGFloat pointY = starPoint.y + lengthOfY * scale;
    return CGPointMake(pointX, pointY);
}
void drawLineInContextFromStartPointAndEndPointWithScale (CGContextRef ctx, CGPoint starPoint, CGPoint endPoint, CGFloat scale, UIColor *storkeColor) {
    CGContextSetStrokeColorWithColor(ctx, storkeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, starPoint.x, starPoint.y);
    CGPoint currentPoint = currentProportionPoint(starPoint, endPoint, scale);
    CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, pointWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}

- (void)drawInContext:(CGContextRef)ctx {
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGPoint firstPoint = CGPointMake(center.x,center.y-viewHeight+pointWidth/2);
    CGPoint secondPoint = CGPointMake(center.x-viewHeight+pointWidth/2, center.y);
    CGPoint thirdPoint = CGPointMake(center.x, center.y+viewHeight-pointWidth/2);
    CGPoint fourthPoint = CGPointMake(center.x+viewHeight-pointWidth/2, center.y);
    if (isAnimationing) {
        CGFloat scale = [(XNFrashLayer *)self.presentationLayer animationScale];
        CGPoint ScaleFirstPoint = currentProportionPoint(center, firstPoint, scale);
        CGPoint ScaleSecondPoint = currentProportionPoint(center, secondPoint, scale);
        CGPoint ScaleThiredPoint = currentProportionPoint(center, thirdPoint, scale);
        CGPoint ScaleFourthPoint = currentProportionPoint(center, fourthPoint, scale);
        
        drawPointAtRect(ScaleFirstPoint,ctx,(XNColor_Hex(0xF5C604)).CGColor);
        drawPointAtRect(ScaleSecondPoint,ctx,XNColor_Hex(0x888889).CGColor);
        drawPointAtRect(ScaleThiredPoint,ctx,XNColor_Hex(0x339999).CGColor);
        drawPointAtRect(ScaleFourthPoint,ctx,XNColor_Hex(0xED7700).CGColor);
    }else {
        //绘制第一个点
        CGFloat firstPA = MIN(1, MAX(0, self.complete/0.2));
        //  NSLog(@"%.2f _complete = %.2f",firstPA,self.complete);
        drawPointAtRect(firstPoint,ctx,(XNColor_HexA(0xF5C604, firstPA)).CGColor);
        if (self.complete>0.225 && self.complete<0.375) {
            //这里要 绘制第一个线条
            if (self.complete<0.3) {
                CGFloat scale = (self.complete-0.225)/0.075;
                drawLineInContextFromStartPointAndEndPointWithScale(ctx, firstPoint, secondPoint, scale,XNColor_HexA(0xF5C604, 1));
            }else {
                CGFloat scale = (0.375-self.complete)/0.075;
                drawLineInContextFromStartPointAndEndPointWithScale(ctx, secondPoint, firstPoint, scale,XNColor_HexA(0xF5C604, 1));
            }
        }else if (self.complete >= 0.375 ) {
            //必定绘制第二个圆
            drawPointAtRect(secondPoint,ctx,XNColor_HexA(0x888889, 1.0).CGColor);
            if (self.complete > 0.425 && self.complete < 0.575) {
                //绘制第二条线条
                if (self.complete<0.5) {
                    CGFloat scale = (self.complete-0.425)/0.075;
                    drawLineInContextFromStartPointAndEndPointWithScale(ctx, secondPoint, thirdPoint, scale,XNColor_HexA(0x888889, 1.0));
                }else {
                    CGFloat scale = (0.575-self.complete)/0.075;
                    drawLineInContextFromStartPointAndEndPointWithScale(ctx, thirdPoint, secondPoint, scale,XNColor_HexA(0x888889, 1.0));
                }
            }else if (self.complete >= 0.575) {
                //必定绘制 第三个圆
                drawPointAtRect(thirdPoint,ctx,XNColor_HexA(0x339999, 1).CGColor);
                if (self.complete > 0.625 && self.complete < 0.775) {
                    //绘制第三条线
                    if (self.complete<0.7) {
                        CGFloat scale = (self.complete-0.625)/0.075;
                        drawLineInContextFromStartPointAndEndPointWithScale(ctx, thirdPoint, fourthPoint, scale,XNColor_HexA(0x339999, 1));
                    }else {
                        CGFloat scale = (0.775-self.complete)/0.075;
                        drawLineInContextFromStartPointAndEndPointWithScale(ctx, fourthPoint, thirdPoint, scale,XNColor_HexA(0x339999, 1));
                    }
                }else if (self.complete >= 0.775) {
                    //必定绘制第四个圆
                    drawPointAtRect(fourthPoint,ctx,XNColor_HexA(0xED7700, 1).CGColor);
                    if (self.complete > 0.825 && self.complete < 0.975) {
                        //绘制第四条线
                        if (self.complete<0.9) {
                            CGFloat scale = (self.complete-0.825)/0.075;
                            drawLineInContextFromStartPointAndEndPointWithScale(ctx, fourthPoint, firstPoint, scale,XNColor_HexA(0xED7700, 1));
                        }else {
                            CGFloat scale = (0.975-self.complete)/0.075;
                            drawLineInContextFromStartPointAndEndPointWithScale(ctx, firstPoint, fourthPoint, scale,XNColor_HexA(0xED7700, 1));
                        }
                    }
                }
            }
        }
    }
}


@end
