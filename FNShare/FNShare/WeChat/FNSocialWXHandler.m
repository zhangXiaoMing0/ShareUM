//
//  FNSocialWXHandler.m
//  FNMarket
//
//  Created by zmx on 2017/2/28.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialWXHandler.h"
#import "WXApi.h"

@interface FNSocialWXHandler ()<WXApiDelegate>

@end

@implementation FNSocialWXHandler

+ (FNSocialWXHandler *)defaultManager
{
    static FNSocialWXHandler *manger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[FNSocialWXHandler alloc] init];
    });
    return manger;
    
}


- (void)fnSocial_setAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret withRedirectURL:(NSString *)redirectURL
{
    [WXApi registerApp:appKey];
}


- (void)fnSocial_ShareWithObject:(FNSocialMessageObject *)object withViewController:(UIViewController *)viewController socialPlatformType:(FNSocialPlatformType)socialPlatformType withCompletionHandler:(FNSocialRequestCompletionHandler)completionHandler
{
    
    self.completionHandler = completionHandler;
    NSString *url = object.webpageUrl;
    NSString *title = object.title;
    NSString *description = object.text;
    id previewImageUrl = object.previewImageUrl;

    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    if (socialPlatformType == FNSocialPlatformType_WechatSession) {
        sendReq.scene = WXSceneSession;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    }else if (socialPlatformType == FNSocialPlatformType_WechatTimeLine){
        sendReq.scene = WXSceneTimeline;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    }
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = title;//分享标题
    urlMessage.description = description;//分享描述
    [urlMessage setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:previewImageUrl]]]];//分享图片
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;//分享链接
    
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    //发送分享信息
    [WXApi sendReq:sendReq];

}

- (BOOL)fnSocial_handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];

}

- (void)onResp:(BaseResp *)resp
{
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    switch (sendResp.errCode) {
        case WXSuccess:
        {
            self.completionHandler(sendResp.errStr,FNSocialPlatformResultType_Success);
            
        }
            break;
        case WXErrCodeUserCancel:
        {
            self.completionHandler(sendResp.errStr,FNSocialPlatformResultType_Cancel);
            
        }
            break;
        case WXErrCodeSentFail:
        {
            self.completionHandler(sendResp.errStr,FNSocialPlatformResultType_ShareFailed);
            
        }
            break;
        default:
            break;
    }
    self.completionHandler(sendResp.errStr,sendResp.errCode);

}

- (BOOL)isFNSocialWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
@end
