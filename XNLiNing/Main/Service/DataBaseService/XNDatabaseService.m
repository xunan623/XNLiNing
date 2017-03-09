//
//  XNDatabaseService.m
//  XNLiNing
//
//  Created by xunan on 2017/3/9.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNDatabaseService.h"
#import "RWDatabaseManager.h"
#import "XNContactModel.h"

NSString *const XNDBName = @"store_data";            //!< 数据库名称
NSString *const DBContactTableName = @"store_data";  //!< 联系人表


@implementation XNDatabaseService

+ (void)openDB {
    NSString *sqlPath = [[NSBundle mainBundle] pathForResource:XNDBName ofType:@"db"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:sqlPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:sqlPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    XNLog(@"db path ---- %@", sqlPath);
    [[RWDatabaseManager shareInstance] open:sqlPath
                                       dict:@{
                                              DBContactTableName : [XNContactModel class]
                                              }];
    
}

+ (void)eachAllContactsData:(void (^)(NSDictionary *dict))each done:(dispatch_block_t)done {
    [[RWDatabaseManager shareInstance] queryAll:DBContactTableName perRow:^(NSDictionary *dict) {
        each(dict);
    } done:^{
        if (done) done();
    }];
}

@end
