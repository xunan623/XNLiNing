//
//  XNClassMainItem.h
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XNClassSubItem;

@interface XNClassMainItem : NSObject

/** 文标题  */
@property (nonatomic, copy ,readonly) NSString *title;


/** goods  */
@property (nonatomic, copy ,readonly) NSArray<XNClassSubItem *> *goods;


@end
