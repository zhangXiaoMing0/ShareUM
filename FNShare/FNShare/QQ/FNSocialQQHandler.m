//
//  FNSocialQQHandler.m
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>

@interface FNSocialQQHandler ()<TencentSessionDelegate,QQApiInterfaceDelegate>

@end

@implementation FNSocialQQHandler

+ (FNSocialQQHandler *)defaultManager
{
    static FNSocialQQHandler *manger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[FNSocialQQHandler alloc] init];
    });
    return manger;

}

- (void)fnSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL
{
    BOOL tecentQQ = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:self]; //注册
    NSLog(@"%ld",tecentQQ);
}

- (void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object
              withViewController:(UIViewController *)viewController
              socialPlatformType:(FNSocialPlatformType)socialPlatformType withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    NSString *url = object.webpageUrl;
    NSString *title = object.title;
    NSString *description = object.text;
    id previewImageUrl = object.previewImageUrl;

    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    if (socialPlatformType == FNSocialPlatformType_QQ) {
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"%d",sent);
    }else if(socialPlatformType == FNSocialPlatformType_Qzone){
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",sent);
    }
}

- (BOOL)fnSocial_handleOpenURL:(NSURL *)url
{
    return  [QQApiInterface handleOpenURL:url delegate:self];
}

- (void)onResp:(QQBaseResp *)resp
{
    QQBaseResp *qqResp = (QQBaseResp *)resp;
    NSInteger errorCode;
    if ([qqResp.result isEqualToString:@"0"]) {
        errorCode = FNSocialPlatformResultType_Success;
    }else if ([qqResp.result isEqualToString:@"-4"]){
        errorCode = FNSocialPlatformResultType_Cancel;
    }
    self.completionHandler(qqResp.result,errorCode);
}

@end
