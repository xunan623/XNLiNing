
#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
         //初始化可变字符串
        NSMutableString *string = [NSMutableString string];
         //拼接开头[
         [string appendString:@"["];
    
         //拼接字典中所有的键值对
         [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                 [string appendFormat:@"%@:",key];
                 [string appendFormat:@"%@",obj];
             }];

        //拼接结尾]
        [string appendString:@"]"];
    
        return string;
}
@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"[\n"];
    
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    
    [str appendString:@"]"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end
