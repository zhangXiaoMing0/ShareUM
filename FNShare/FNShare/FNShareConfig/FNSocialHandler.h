//
//  FNSocialHandler.h
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNSocialConfig.h"
#import "FNSocialPlatformProvider.h"

@interface FNSocialHandler : NSObject<FNSocialPlatformProvider>

#pragma mark - 子类需要重载的类
+ (FNSocialHandler *)defaultManager;

#pragma mark -

@property (nonatomic, copy) FNSocialRequestCompletionHandler completionHandler;

@property (nonatomic, copy) NSString *appID;

@property (nonatomic, copy) NSString *appSecret;

@property (nonatomic, copy) NSString *redirectURL;
@end
