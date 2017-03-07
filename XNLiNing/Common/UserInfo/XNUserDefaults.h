//
//  XNUserDefaults.h
//  XNLiNing
//
//  Created by xunan on 2017/3/6.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNUserDefaults : NSObject

@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *provinceArea;
@property (nonatomic, copy) NSString<Optional> *userPassword;
@property (nonatomic, copy) NSString<Optional> *userXingming;
@property (nonatomic, copy) NSString<Optional> *userType;
@property (nonatomic, copy) NSString<Optional> *modiyfUser;
@property (nonatomic, copy) NSString<Optional> *deptId;
@property (nonatomic, copy) NSString<Optional> *createUser;
@property (nonatomic, copy) NSString<Optional> *bigArea;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) NSString<Optional> *isUpdate;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *modifyStatus;

@end
