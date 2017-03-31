//
//  XNSettingModel.h
//  XNLiNing
//
//  Created by xunan on 2017/3/31.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNSettingModel : NSObject

/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** id */
@property (nonatomic, assign) NSInteger titleId;

@end
