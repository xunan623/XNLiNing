//
//  XNBaseModel.h
//  XNLiNing
//
//  Created by xunan on 2017/3/3.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XNBaseModel : JSONModel

@property (nonatomic, copy) NSString *failMessage;
@property (nonatomic, copy) NSString *maxPage;
@property (nonatomic, copy) NSString *retVal;

@end
