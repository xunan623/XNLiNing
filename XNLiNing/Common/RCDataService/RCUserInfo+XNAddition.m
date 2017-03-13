//
//  RCUserInfo+XNAddition.m
//  XNLiNing
//
//  Created by xunan on 2017/3/10.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "RCUserInfo+XNAddition.h"
#import <objc/message.h>

@implementation RCUserInfo (XNAddition)


- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait QQ:(NSString *)QQ sex:(NSString *)sex {
    if (self = [super init]) {
        self.userId        =   userId;
        self.name          =   username;
        self.portraitUri   =   portrait;
        self.QQ         =   QQ;
        self.sex   =   sex;
    }
    return self;
}

// 添加属性款子set方法
static char * const QQ = "QQ";
static char * const SEX = "SEX";

- (void)setQQ:(NSString *)newQQ {
    objc_setAssociatedObject(self, QQ, newQQ, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSex:(NSString *)newSEX {
    
    objc_setAssociatedObject(self,SEX,newSEX,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


//添加属性扩展get方法
-(NSString *)QQ{
    return objc_getAssociatedObject(self,QQ);
}
-(NSString *)sex{
    return objc_getAssociatedObject(self,SEX);
}


@end
