//
//  XNDatabaseService.h
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const XNDBName;            //!< 数据库名称
FOUNDATION_EXTERN NSString *const DBContactTableName;  //!< 联系人表


@interface XNDatabaseService : NSObject

+ (void)openDB;

#pragma mark - 查询所有联系人列表
+ (void)eachAllContactsData:(void (^)(NSDictionary *dict))each done:(dispatch_block_t)done;


@end
