//
//  FNSocialHandler.m
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialHandler.h"

@implementation FNSocialHandler

+ (FNSocialHandler *)defaultManager
{
    static FNSocialHandler *manger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[FNSocialHandler alloc] init];
    });
    return manger;
}

- (void)fnSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL
{
    
}

- (void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object
              withViewController:(UIViewController *)viewController
              socialPlatformType:(FNSocialPlatformType)socialPlatformType withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler
{
    
}

- (void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object
    socialPlatformType:(FNSocialPlatformType)socialPlatformType withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler
{
    
}

- (BOOL)fnSocial_handleOpenURL:(NSURL *)url
{
    return YES;
}
@end
