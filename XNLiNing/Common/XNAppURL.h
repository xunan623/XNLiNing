//
//  XNAppURL.h
//  XNLiNing
//
//  Created by xunan on 2017/3/1.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNAppURL : NSObject

FOUNDATION_EXTERN NSString *const AppRequestURL;

FOUNDATION_EXTERN NSString *const AppRequestURL_ContactTree;            // 联系人
FOUNDATION_EXTERN NSString *const AppRequestURL_imagePath;              // 图片路径
FOUNDATION_EXTERN NSString *const AppRequestURL_loginApp;               // 登录
FOUNDATION_EXTERN NSString *const AppRequestURL_infoApp;                // 消息列表
FOUNDATION_EXTERN NSString *const AppRequestURL_attApp;                 // 附件
FOUNDATION_EXTERN NSString *const AppRequestURL_dictApp;                // 数据字典
FOUNDATION_EXTERN NSString *const AppRequestURL_itemApp;                // 店长反馈
FOUNDATION_EXTERN NSString *const AppRequestURL_followApp;              // 任务跟进
FOUNDATION_EXTERN NSString *const AppRequestURL_shopListApp;            // 任务跟进详情
FOUNDATION_EXTERN NSString *const AppRequestURL_shopIdListApp;          // 获取shopId
FOUNDATION_EXTERN NSString *const AppRequestURL_uploadApp;              // 上传照片
FOUNDATION_EXTERN NSString *const AppRequestURL_savePicInfoApp;         // 照片提交主信息保存
FOUNDATION_EXTERN NSString *const AppRequestURL_downloadFileMobileApp;  // 下载附件
FOUNDATION_EXTERN NSString *const AppRequestURL_updateInfoApp;          // 修改手机号
FOUNDATION_EXTERN NSString *const AppRequestURL_findUserInfoApp;        // 获取手机号
FOUNDATION_EXTERN NSString *const AppRequestURL_getItemImgsApp;         // 图片墙
FOUNDATION_EXTERN NSString *const AppRequestURL_reportApp;              // 查看报表


FOUNDATION_EXTERN NSString *const AppRongCloudAppKey;                   // 荣云key
FOUNDATION_EXTERN NSString *const AA55_Token;                           // AA55_Token


@end
