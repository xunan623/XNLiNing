//
//  XNGlobalConst.h
//  XNToolDemo
//
//  Created by xunan on 2016/12/30.
//  Copyright © 2016年 xunan. All rights reserved.
//

#ifndef XNGlobalConst_h
#define XNGlobalConst_h


// 获取工程中的文件
#define XNProject_File(__fileName__) [[NSBundle mainBundle] pathForResource:__fileName__ ofType:nil]

// 获取key window
#define XNKeyWindow [UIApplication sharedApplication].keyWindow

// 从xib中加载View
#define XNLoadXibWithClass(__class__) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([__class__ class]) owner:self options:nil] firstObject]

// 获取屏幕大小
#define XNScreen_Bounds [UIScreen mainScreen].bounds
#define XNScreen_Size XNScreen_Bounds.size
#define XNScreen_Width XNScreen_Size.width
#define XNScreen_Height XNScreen_Size.height

// 常用系统的高度
#define XNHeight_TabBar           49.0f
#define XNHeight_NavigationBar    44.0f
#define XNHeight_StatusBar        20.0f
#define XNHeight_TopBar   XNHeight_NavigationBar + XNHeight_StatusBar

// 字体
#define XNFont_System(size) [UIFont systemFontOfSize:size]
#define XNFont_System_Bold(size) [UIFont boldSystemFontOfSize:size]


// 颜色
#define XNColor_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define XNColor_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XNColor_Hex(hexValue)   [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]
#define XNRandomColor ZYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 图片
#define XNImage_Named(name) [UIImage imageNamed:name]
#define XNImage_File(file, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
#define XNImage_FileFullName(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

// 沙盒路径
#define XNSandBox_Documents [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define XNSandBox_Caches    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define XNSandBox_Temporary NSTemporaryDirectory()
#define XnSandBox_Root      NSHomeDirectory()



// 打印
#ifdef DEBUG
#define XNLog(...) NSLog(__VA_ARGS__)
#else
#define XNLog(...)
#endif

#define XNLogFunc NSLog(@"%s", __func__)
#endif


