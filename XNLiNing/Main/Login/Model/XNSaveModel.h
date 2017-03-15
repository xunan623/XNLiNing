//
//  XNSaveModel.h
//  XNLiNing
//
//  Created by xunan on 2017/3/15.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNBaseRes.h"
#import <WHC_ModelSqlite.h>

@interface XNSaveContentModel : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) CGFloat height;

@end

@interface XNSaveModel : XNBaseRes

@property (strong, nonatomic)XNSaveContentModel *content;
@property (nonatomic, copy) NSString *record;
@property (nonatomic, copy) NSString *userId;

+ (NSString *)whc_SqliteVersion;

@end


