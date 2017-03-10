//
//  FNSocialPlatformProvider.h
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNSocialConfig.h"
#import "FNSocialMessageObject.h"

@protocol FNSocialPlatformProvider <NSObject>

@optional


/**
 *  初始化平台
 *
 *  @param appKey      对应的appkey
 *  @param appSecret   对应的appSecret
 *  @param redirectURL 对应的重定向url
 *  @discuss appSecret和redirectURL如果平台必须要的话就传入，不需要就传入nil
 */
-(void)fnSocial_setAppKey:(NSString *)appKey
            withAppSecret:(NSString *)appSecret
          withRedirectURL:(NSString *)redirectURL;


/**
 *  分享
 *
 *  @param object            分享的对象数据模型
 *  @param completionHandler 分享后的回调
 */
-(void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object
             socialPlatformType:(FNSocialPlatformType)socialPlatformType
          withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler;

/**
 *  分享
 *
 *  @param object            分享的对象数据模型
 *  @param completionHandler 分享后的回调
 *  @parm  viewController   分享需要的viewController
 *  @dicuss 这个函数用于sms,email等需要传入viewController的平台
 */
-(void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object
             withViewController:(UIViewController*)viewController
             socialPlatformType:(FNSocialPlatformType)socialPlatformType
          withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)fnSocial_handleOpenURL:(NSURL *)url;


/**
 是否安装微信

 @return YES安装 NO没安装
 */
- (BOOL)isFNSocialWXAppInstalled;

@end
