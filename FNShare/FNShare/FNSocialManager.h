//
//  FNSocialManager.h
//  FNMarket
//
//  Created by zmx on 2017/2/21.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNSocialConfig.h"
#import "FNSocialPlatformProvider.h"


@class FNSocialMessageObject;


@interface FNSocialManager : NSObject

+(instancetype)defaultManager;

+ (BOOL)isWXAppInstalled;
/**
 *  设置平台的appkey
 *
 *  @param platformType 平台类型 @see FNSocialPlatformType
 *  @param appKey       第三方平台的appKey（QQ平台为appID）
 *  @param appSecret    第三方平台的appSecret（QQ平台为appKey）
 *  @param redirectURL  redirectURL
 */
- (BOOL)setPlaform:(FNSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;


/**
 *  设置分享平台
 *
 *  @param platformType  平台类型 @see FNSocialPlatformType
 *  @param messageObject  分享的content @see FNSocialMessageObject
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 *  @discuss currentViewController 只正对sms,email等平台需要传入viewcontroller的平台，其他不需要的平台可以传入nil
 */
- (void)shareToPlatform:(FNSocialPlatformType)platformType
          messageObject:(FNSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(FNSocialRequestCompletionHandler)completion;


/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)handleOpenURL:(NSURL *)url;
@end
