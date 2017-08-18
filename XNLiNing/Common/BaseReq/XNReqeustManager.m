//
//  XNReqeustManager.m
//  XNLiNing
//
//  Created by xunan on 2017/8/16.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNReqeustManager.h"
#import "XNReqeustCache.h"
#import <AFNetworkActivityIndicatorManager.h>

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@interface XNReqeustManager()


@end

@implementation XNReqeustManager

static BOOL _isOpenLog; // 是否已经开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 初始化 AFHTTPSessionManager

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 15.0f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                 @"application/json",
                                                                 @"text/html",
                                                                 @"text/json",
                                                                 @"text/plain",
                                                                 @"text/javascript",
                                                                 @"text/xml",
                                                                 @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}



#pragma mark - 开始监听网络

+ (void)networkStatusWithBlock:(XNNetworkStatus)networkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(XNNetworkStatusUnknown) : nil;
                if (_isOpenLog) XNLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(XNNetworkStatusNotReachable) : nil;
                if (_isOpenLog) XNLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(XNNetworkStatusReachableViaWWAN) : nil;
                if (_isOpenLog) XNLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(XNNetworkStatusReachableViaWiFi) : nil;
                if (_isOpenLog) XNLog(@"WIFI");
                break;
            default:
                break;
        }
    }];
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) return;
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET 请求无缓存

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(XNHTTPRequestSuccess)success
                  failure:(XNHTTPRequestFailed)failure {
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - GET 请求有缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(XNHTTPReqeustCache)responseCache
                  success:(XNHTTPRequestSuccess)success
                  failure:(XNHTTPRequestFailed)failure {
    // 读取缓存
    if (responseCache) responseCache([XNReqeustCache httpCacheForURL:URL parameters:parameters]);
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_isOpenLog) XNLog(@"responseObject = %@", responseObject);
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
        // 数据异步缓存
        responseCache ? [XNReqeustCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (_isOpenLog) XNLog(@"error = %@", error);
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组中
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    
    return sessionTask;
}

#pragma mark - POST 请求无缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(XNHTTPRequestSuccess)success
                   failure:(XNHTTPRequestFailed)failure {
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - POST 请求有缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(XNHTTPReqeustCache)responseCache
                   success:(XNHTTPRequestSuccess)success
                   failure:(XNHTTPRequestFailed)failure {
    // 读取缓存
    responseCache ? responseCache([XNReqeustCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * uploadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if (_isOpenLog) XNLog(@"responseObject = %@", responseObject);
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
        // 对数据进行异步缓存
        responseObject ? [XNReqeustCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if (_isOpenLog) XNLog(@"error = %@", error);
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        
    }];
    
    // 添加sessionTask到数组中
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil;
    
    return sessionTask;
}

#pragma mark - 上传文件

+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(XNHTTPProgress)progress
                                success:(XNHTTPRequestSuccess)success
                                failure:(XNHTTPRequestFailed)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
        
    } progress:^(NSProgress * uploadProgress) {
        
        // 上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
        
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
    
        if (_isOpenLog) { XNLog(@"responseObject = %@", responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        if (_isOpenLog) XNLog(@"error = %@", error);
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;

    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;

    return sessionTask;
}

#pragma mark - 上传多张图片

+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale imageType:(NSString *)imageType
                                 progress:(XNHTTPProgress)progress success:(XNHTTPRequestSuccess)success
                                  failure:(XNHTTPRequestFailed)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        
        for (NSInteger i = 0; i< images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ? : 1.f);
            
            // 默认图片的文件名, 若fileNames为nil 就使用
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];

        }
        
    } progress:^(NSProgress * uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (_isOpenLog) { XNLog(@"responseObject = %@", responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        if (_isOpenLog) XNLog(@"error = %@", error);
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;

    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(XNHTTPProgress)progress
                              success:(void (^)(NSString *))success
                              failure:(XNHTTPRequestFailed)failure {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        // 下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // 拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;

    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

/**
 * 存储所有的请求task数据组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [NSMutableArray array];
    }
    return _allSessionTask;
}


#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(XNReqeustSerializer)reqeustSerializer {
    _sessionManager.requestSerializer = reqeustSerializer == XNReqeustSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(XNResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer == XNResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}
@end
