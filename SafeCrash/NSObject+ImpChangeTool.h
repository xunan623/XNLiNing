//
//  NSObject+ImpChangeTool.h
//  Agency
//
//  Created by MacAir on 2018/1/25.
//  Copyright © 2018年 centanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ImpChangeTool)

+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString;
@end
