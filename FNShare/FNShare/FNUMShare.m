//
//  FNUMShare.m
//  FNMarket
//
//  Created by zmx on 15/7/24.
//  Copyright (c) 2015年 cn.com.feiniu. All rights reserved.
//

#import "FNUMShare.h"
#import "FNSocialManager.h"

#define QQAppID     @"222222"
#define QQAppKey    @""
#define WxAppID @"wxd930ea5d5a258f4f"
#define WxAppSecret @""

@implementation FNUMShare

+ (void)configureUMShare
{
    [[FNSocialManager defaultManager] setPlaform:FNSocialPlatformType_QQ appKey:QQAppID appSecret:QQAppKey redirectURL:@"http://www.feiniu.com"];
    [[FNSocialManager defaultManager] setPlaform:FNSocialPlatformType_WechatSession appKey:WxAppID  appSecret:WxAppSecret redirectURL:@"http://www.feiniu.com"];
    [[FNSocialManager defaultManager] setPlaform:FNSocialPlatformType_Sina appKey:@"2045436852"  appSecret:@"" redirectURL:@"http://www.sina.com"];
}
@end
