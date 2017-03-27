//
//  XNChatSystemMessage.m
//  XNLiNing
//
//  Created by xunan on 2017/3/27.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNChatSystemMessage.h"

@implementation XNChatSystemMessage

+ (instancetype)messageWithContent:(NSString *)content {
    XNChatSystemMessage *msg = [[XNChatSystemMessage alloc] init];
    if (msg) {
        msg.content = content;
    }
    return msg;
}

+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    
}

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    if (json) {
        self.content = json[@"content"];
        self.extra = json[@"extra"];
        
        NSDictionary *userinfoDic = json[@"user"];
        [self decodeUserInfo:userinfoDic];
        
    }
    
}

- (NSString *)conversationDigest {
    return self.content;
    
}

+(NSString *)getObjectName {
    return RTLocalMessage;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
