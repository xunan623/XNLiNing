//
//  XNSaveUserDefault.m
//  XNLiNing
//
//  Created by xunan on 2017/3/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSaveUserDefault.h"

@implementation XNSaveUserDefault

+ (instancetype)saveUserDefaultWith:(XNLoginContent *)content {
    return [[self alloc] initWithModel:content];
}

- (instancetype)initWithModel:(XNLoginContent *)content {
    if (self = [super init]) {
        [self saveWithModel:content];
    }
    return self;
}

- (void)saveWithModel:(XNLoginContent *)content {
    XNUserDefaults *ud = [XNUserDefaults new];
    ud.id = content.id;
    ud.provinceArea = content.provinceArea;
    ud.userPassword = content.userPassword;
    ud.userXingming = content.userXingming;
    ud.userType = content.userType;
    ud.modiyfUser = content.modiyfUser;
    ud.deptId = content.deptId;
    ud.createUser = content.createUser;
    ud.bigArea = content.bigArea;
    ud.userName = content.userName;
    ud.createTime = content.createTime;
    ud.isUpdate = content.isUpdate;
    ud.status = content.status;
    ud.modifyStatus = content.modifyStatus;
}

@end
