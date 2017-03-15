//
//  XNTaskModel.h
//  XNLiNing
//
//  Created by xunan on 2017/3/15.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseRes.h"

@interface XNTaskContent : JSONModel


@end

@protocol XNTaskContent <NSObject>

@end

@interface XNTaskModel : XNBaseRes

@property (strong, nonatomic) NSArray<XNTaskContent, Optional> *list;


@end
