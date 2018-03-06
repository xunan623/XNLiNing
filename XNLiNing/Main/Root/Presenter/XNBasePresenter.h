//
//  XNBasePresenter.h
//  XNLiNing
//
//  Created by Dandre on 2018/3/6.
//  Copyright © 2018年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNBasePresenter<View> : NSObject

@property (nonatomic, weak) id presentV;

- (instancetype)initWithView:(id)view;

@end
