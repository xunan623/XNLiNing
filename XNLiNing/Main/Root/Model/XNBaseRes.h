//
//  XNBaseRes.h
//  XNLiNing
//
//  Created by xunan on 2017/3/7.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XNBaseRes : JSONModel

@property (nonatomic, copy) NSString *failMessage;
@property (nonatomic, copy) NSString *maxPage;
@property (nonatomic, copy) NSString *retVal;

@end
