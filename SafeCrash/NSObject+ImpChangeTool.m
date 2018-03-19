//
//  NSObject+ImpChangeTool.m
//  Agency
//
//  Created by MacAir on 2018/1/25.
//  Copyright © 2018年 centanet. All rights reserved.
//

#import "NSObject+ImpChangeTool.h"

#import <objc/runtime.h>

@implementation NSObject (ImpChangeTool)

+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString{

    Class  sys=NSClassFromString(systemClassString);
    Class  safe=NSClassFromString(targetClassString);
    
    SEL sysSel=NSSelectorFromString(systemMethodString);
    SEL safeSel=NSSelectorFromString(safeMethodString);
    
    if(sys&&safe){
        if([sys instancesRespondToSelector:sysSel]&&[safe instancesRespondToSelector:safeSel]){
            
            Method sysMethod = class_getInstanceMethod(sys, sysSel);
            
            Method safeMethod = class_getInstanceMethod(safe, safeSel);

            if(sysMethod&&safeMethod){
                method_exchangeImplementations(safeMethod,sysMethod);
            }
            
        }
    }
}
@end
