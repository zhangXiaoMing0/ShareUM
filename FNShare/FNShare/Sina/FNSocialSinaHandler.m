//
//  FNSocialSinaHandler.m
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialSinaHandler.h"
#import "WeiboSDK.h"

@interface FNSocialSinaHandler ()<WeiboSDKDelegate>

@end

@implementation FNSocialSinaHandler

+ (FNSocialSinaHandler *)defaultManager
{
    static FNSocialSinaHandler *manger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[FNSocialSinaHandler alloc] init];
    });
    return manger;
    
}


- (void)fnSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL
{
    self.redirectURL = redirectURL;
    [WeiboSDK registerApp:appKey];

}

- (void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object withViewController:(UIViewController *)viewController socialPlatformType:(FNSocialPlatformType)socialPlatformType withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler
{
    
    self.completionHandler = completionHandler;
    NSString *description = object.text;
    id previewImageUrl = object.previewImageUrl;

    if (![WeiboSDK isWeiboAppInstalled]) {
        self.completionHandler(@"",FNSocialPlatformResultType_NotInstall);
    }else {
        WBMessageObject *message = [WBMessageObject message];
        message.text = description;
        WBImageObject *image = [WBImageObject object];
        
        image.imageData = UIImageJPEGRepresentation(previewImageUrl, 1.0);
        message.imageObject = image;
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = self.redirectURL;
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        [WeiboSDK sendRequest:request];
    }
}

- (BOOL)fnSocial_handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark -- weibo callBack
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeSuccess:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_Success);
        }
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_Cancel);
        }
            break;
        case WeiboSDKResponseStatusCodeSentFail:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_ShareFailed);
        }
            break;
        default:
            break;
    }
}

@end
