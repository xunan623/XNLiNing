//
//  NSString+Ext.m
//  centanet
//
//  Created by Ranger on 16/8/8.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString (Ext)

#pragma mark-- 求取一般字符串高度
-(CGFloat)getStringHeight:(UIFont*)font width:(CGFloat)width
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    
    return stringRect.size.height;
}

#pragma mark-- 求取一般字符串宽度

-(CGFloat)getStringWidth:(UIFont*)font Height:(CGFloat)height{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                         
                                                       context:nil];
    
    return stringRect.size.width;
}

#pragma mark-- 求取特殊字符串高度

-(CGFloat)mutableAttributedStringWithFont:(UIFont *)font
                                    width:(CGFloat)width
                             andLineSpace:(CGFloat)lineSpace
{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  paragraphStyle, NSParagraphStyleAttributeName,
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    
    return stringRect.size.height;
}

- (CGSize)stringSize:(UIFont *)font regularHeight:(CGFloat)height {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attrSyleDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  font, NSFontAttributeName,
                                  nil];
    
    [attributedString addAttributes:attrSyleDict
                              range:NSMakeRange(0, self.length)];
    CGRect stringRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil];
    return stringRect.size;
}

#pragma mark-  是否有连续几位的数字

- (BOOL)hasSerialNumber:(NSUInteger)num {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (self.length > num - 1) {
        for (int i = 0; i < self.length - (num - 1); i ++) {
            NSRange range = NSMakeRange(i, num);
            NSString *temp = [self substringWithRange:range];
            [arr addObject:temp];
        }
        for (NSString *tempStr in arr) {
            if ([tempStr isPureInt]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark-  空字符验证
- (BOOL)matchBlankSpace {
    
    NSString *pattern = @"[\\w\\s]*\\n*[\\s]*[\\n][\\w\\s]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

#pragma mark-  是否为纯数字
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark-  是否为有效的手机国家码
- (BOOL)isValidMobliePhoneCountryCode {
    NSString * pattern = @"^(619164|619162|244|93|355|213|376|1264|1268|54|374|247|61|43|994|1242|973|880|1246|375|32|501|229|1441|591|267|55|673|359|226|95|257|237|1|1345|236|235|56|86|57|242|682|506|53|357|420|45|253|1890|593|20|503|372|251|679|358|33|594|241|220|995|49|233|350|30|1809|1671|502|224|592|509|504|852|36|354|91|62|98|964|353|972|39|225|1876|81|962|855|327|254|82|965|331|856|371|961|266|231|218|423|370|352|853|261|265|60|960|223|356|1670|596|230|52|373|377|976|1664|212|258|264|674|977|599|31|64|505|227|234|850|47|968|92|507|675|595|51|63|48|689|351|1787|974|262|40|7|1758|1784|684|685|378|239|966|221|248|232|65|421|386|677|252|27|34|94|1758|1784|249|597|268|46|41|963|886|992|255|66|228|676|1809|216|90|993|256|380|971|44|1|598|233|58|84|967|381|263|243|260)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  是否为有效的固话区号
- (BOOL)isValidTelephoneAreaCode {
    NSString * pattern = @"^(010|021|022|023|852|853|0310|0311|0312|0313|0314|0315|0316|0317|0318|0319|0335|0570|0571|0572|0573|0574|0575|0576|0577|0578|0579|0580|024|0410|0411|0412|0413|0414|0415|0416|0417|0418|0419|0421|0427|0429|027|0710|0711|0712|0713|0714|0715|0716|0717|0718|0719|0722|0724|0728|025|0510|0511|0512|0513|0514|0515|0516|0517|0518|0519|0523|0470|0471|0472|0473|0474|0475|0476|0477|0478|0479|0482|0483|0790|0791|0792|0793|0794|0795|0796|0797|0798|0799|0701|0350|0351|0352|0353|0354|0355|0356|0357|0358|0359|0930|0931|0932|0933|0934|0935|0936|0937|0938|0941|0943||0530|0531|0532|0533|0534|0535|0536|0537|0538|0539|0450|0451|0452|0453|0454|0455|0456|0457|0458|0459|0591|0592|0593|0594|0595|0595|0596|0597|0598|0599|020|0751|0752|0753|0754|0755|0756|0757|0758|0759|0760|0762|0763|0765|0766|0768|0769|0660|0661|0662|0663|028|0810|0811|0812|0813|0814|0816|0817|0818|0819|0825|0826|0827|0830|0831|0832|0833|0834|0835|0836|0837|0838|0839|0840|0730|0731|0732|0733|0734|0735|0736|0737|0738|0739|0743|0744|0745|0746|0370|0371|0372|0373|0374|0375|0376|0377|0378|0379|0391|0392|0393|0394|0395|0396|0398|0870|0871|0872|0873|0874|0875|0876|0877|0878|0879|0691|0692|0881|0883|0886|0887|0888|0550|0551|0552|0553|0554|0555|0556|0557|0558|0559|0561|0562|0563|0564|0565|0566|0951|0952|0953|0954|0431|0432|0433|0434|0435|0436|0437|0438|0439|0440|0770|0771|0772|0773|0774|0775|0776|0777|0778|0779|0851|0852|0853|0854|0855|0856|0857|0858|0859|029|0910|0911|0912|0913|0914|0915|0916|0917|0919|0971|0972|0973|0974|0975|0976|0977|0890|0898|0899|0891|0892|0893)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  是否为有效的手机号码
- (BOOL)isValidMobilePhoneCode {
    NSString *pattern = @"^(0|17951)?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8}$";//手机号码正则
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  是否为国外的手机
- (BOOL)isValidMobilePhoneForiCode {
    NSString *pattern = @"^[0-9]{6,11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  验证email地址
- (BOOL)isValidEmailCode {
    NSString *pattern = @"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  是否是有效的固话号码
- (BOOL)isValidFixedTelephone {
    NSString *pattern = @"^[0-9]{7,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark-  是否为国外固话
- (BOOL)isValidFixedForiTelephone {
    NSString *pattern = @"^[0-9]{6,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}
#pragma mark - md5加密
+ (NSString *)getMd5Code:(NSString *)md5Code;
{
    const char *cStr = [md5Code UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark - 字符串unicode编码
+(NSString *) utf8ToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >= '0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
        }
        
        else if(_char >= 'a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else if(_char >= 'A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else
            
        {
        
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            
        }
        
    }
    
    return s;
    
}

@end



@implementation NSString (MJExtension)
- (NSString *)underlineFromCamel
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)camelFromUnderline
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

- (NSString *)firstCharLower
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)firstCharUpper
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (BOOL)isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSURL *)url
{
    return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
}
@end



#pragma mark-  FolderPath

@implementation NSString (FolderPath)

+ (NSString *)documentsPath {
    return [self searchPathFrom:NSDocumentDirectory];
}

+ (NSString *)cachesPath {
    return [self searchPathFrom:NSCachesDirectory];
}

+ (NSString *)documentsContentDirectory:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [self documentsPath], name];
}

+ (NSString *)cachesContentDirectory:(NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [self cachesPath], name];
}

#pragma mark-  private methods

+ (NSString *)searchPathFrom:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

@end



#pragma mark-  Project

@implementation NSString (Project)

+ (NSString *)shortVersion {
    return [self objectFromMainBundleForKey:@"CFBundleShortVersionString"];
}

+ (NSInteger)buildVersion {
    return [self objectFromMainBundleForKey:@"CFBundleVersion"].integerValue;
}

+ (NSString *)identifier {
    return [self objectFromMainBundleForKey:@"CFBundleIdentifier"];
}

+ (NSString *)objectFromMainBundleForKey:(NSString *)key {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  [infoDictionary objectForKey:key];
}

+ (NSString *)uuid {
    // 生成随机不重复的uuid
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *str_uuid = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    
    // OC风格的创建 ：NSString *str_uuid = [[NSUUID UUID] UUIDString];
    // 将生成的uuid中的@"-"去掉
    NSString *str_name = [str_uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(puuid);
    CFRelease(uuidString);
    return str_name;
}


@end


