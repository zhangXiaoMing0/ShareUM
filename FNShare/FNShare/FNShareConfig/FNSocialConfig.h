//
//  FNSocialConfig.h
//  FNMarket
//
//  Created by zmx on 2017/2/21.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FNSocialPlatformType)
{
    FNSocialPlatformType_Predefine_Begin    = -1,
    FNSocialPlatformType_Sina               = 0, //新浪
    FNSocialPlatformType_WechatSession      = 1, //微信聊天
    FNSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    FNSocialPlatformType_WechatFavorite     = 3,//微信收藏
    FNSocialPlatformType_QQ                 = 4,//QQ聊天页面
    FNSocialPlatformType_Qzone              = 5,//QQ空间
    FNSocialPlatformType_Sms                = 6,//短信
    
    //用户自定义的平台
    FNSocialPlatformType_UserDefine_Begin = 1000,
    FNSocialPlatformType_UserDefine_End = 2000,
};


/**
 *  U-Share返回错误类型
 */
typedef NS_ENUM(NSInteger, FNSocialPlatformResultType) {
    FNSocialPlatformResultType_Success           = 0   ,             //成功
    FNSocialPlatformResultType_Cancel            = 2001,             // 取消操作
    FNSocialPlatformResultType_NotInstall        = 2002,             // 应用未安装
    FNSocialPlatformResultType_ShareFailed       = 2003,            // 分享失败
    FNSocialPlatformResultType_Unknow            = 2004,            // 未知错误
    FNSocialPlatformResultType_NotSupport        = 2005,            // 不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持）
    FNSocialPlatformResultType_AuthorizeFailed   = 2006,            // 授权失败
    FNSocialPlatformResultType_RequestForUserProfileFailed = 2007,  // 请求用户信息失败
    FNSocialPlatformResultType_ShareDataNil      = 2008,             // 分享内容为空
    FNSocialPlatformResultType_ShareDataResultTypeIllegal = 2009,          // 分享内容不支持
    FNSocialPlatformResultType_SourceError      = 2010,             // 第三方错误
};


/**
 *  授权，分享，UserProfile等操作的回调
 *
 *  @param result 表示回调的结果
 *  @param error  表示回调的错误码
 */
typedef void (^FNSocialRequestCompletionHandler)(id result,NSInteger errorCode);

@interface FNSocialConfig : NSObject

@property(nonatomic,strong)NSString* appKey;
@property(nonatomic,strong)NSString* appSecret;
@property(nonatomic,strong)NSString* redirectURL;



@end
