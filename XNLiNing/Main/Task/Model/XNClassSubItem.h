//
//  XNClassSubItem.h
//  XNLiNing
//
//  Created by xunan on 2017/7/24.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNClassSubItem : NSObject
/** 商品类题  */
@property (nonatomic, copy ,readonly) NSString *goods_title;

/** 商品图片  */
@property (nonatomic, copy ,readonly) NSString *image_url;

@end
