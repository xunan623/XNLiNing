//
//  XNReqeustManager.h
//  XNLiNing
//
//  Created by xunan on 2017/8/16.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, XNNetworkStatusType) {
    // 未知忘了
    XNNetworkStatusUnknown,
    // 无网路
    XNNetworkStatusNotReachable,
    // 手机
    XNNetworkStatusReachableViaWWAN,
    // WIFI网路
    XNNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, XNReqeustSerializer) {
    // 设置请求数据为JSON格式
    XNReqeustSerializerJSON,
    // 设置相应数据为二进制格式
    XNReqeustSerializerHTTP
};

typedef NS_ENUM(NSUInteger, XNResponseSerializer) {
    XNResponseSerializerJSON,
    XNResponseSerializerHTTP
};

/// 成功
typedef void (^XNHTTPRequestSuccess)(id responseObject);

/// 失败
typedef void (^XNHTTPRequestFailed)(NSError *error);

/// 缓存
typedef void (^XNHTTPReqeustCache)(id responseCache);

/// 上传或者下载的进度, progress.completedUnitCount:当前大小  progress.totalUnitCount:总大小
typedef void (^XNHTTPProgress)(NSProgress *progress);

typedef void (^XNNetworkStatus)(XNNetworkStatusType status);


@interface XNReqeustManager : NSObject

/**
 * 是否有网络
 */
+ (BOOL)isNetwork;
/**
 * 手机网络
 */
+ (BOOL)isWWANNetwork;
/**
 * wifi
 */
+ (BOOL)isWiFiNetwork;

/**
 * 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 * 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(XNNetworkStatus)networkStatus;

/**
 * 取消置顶的url的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;


/**
 * 开启日志打印 (Debug级别)
 */
+ (void)openLog;

/**
 * 关闭日志打印,默认关闭
 */
+ (void)closeLog;

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(XNHTTPRequestSuccess)success
                  failure:(XNHTTPRequestFailed)failure;

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(XNHTTPReqeustCache)responseCache
                  success:(XNHTTPRequestSuccess)success
                  failure:(XNHTTPRequestFailed)failure;

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(XNHTTPRequestSuccess)success
                   failure:(XNHTTPRequestFailed)failure;

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(XNHTTPReqeustCache)responseCache
                   success:(XNHTTPRequestSuccess)success
                   failure:(XNHTTPRequestFailed)failure;

/**
 *  上传文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(XNHTTPProgress)progress
                                success:(XNHTTPRequestSuccess)success
                                failure:(XNHTTPRequestFailed)failure;

/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name: (NSString *)name
                                   images:(NSArray<UIImage *>*)images
                                fileNames:(NSArray<NSString *>*)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(XNHTTPProgress)progress
                                  success:(XNHTTPRequestSuccess)success
                                  failure:(XNHTTPRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(XNHTTPProgress)progress
                              success:(void(^)(NSString *filePath))success
                              failure:(XNHTTPRequestFailed)failure;


#pragma mark 设置 AFHTTPSessionManager相关属性

#pragma mark 注意: 因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效

+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer XNRequestSerializerJSON(JSON格式),XNRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(XNReqeustSerializer)reqeustSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer XNResponseSerializerJSON(JSON格式),XNResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(XNResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;


@end
