//
//  FNSocialManager.m
//  FNMarket
//
//  Created by zmx on 2017/2/21.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialManager.h"
#import "FNSocialMessageObject.h"
#import "FNSocialHandler.h"

#import <MessageUI/MFMessageComposeViewController.h>

@interface FNSocialManager ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) FNSocialRequestCompletionHandler completionHandler;
@property (nonatomic, assign) FNSocialPlatformType platformType;
@property (nonatomic, strong) MFMessageComposeViewController *messagePicker;

@end

@implementation FNSocialManager

+ (instancetype)defaultManager
{
    static FNSocialManager *manger = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[FNSocialManager alloc] init];
    });
    return manger;
}

#pragma mark -- appkey appSecret
- (BOOL)setPlaform:(FNSocialPlatformType)platformType appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL
{
    
    switch (platformType) {
        case FNSocialPlatformType_QQ:
        case FNSocialPlatformType_Qzone:
        {
            id class = NSClassFromString(@"FNSocialQQHandler");
            if (class) {
                if ([[class defaultManager] respondsToSelector:@selector(fnSocial_setAppKey:withAppSecret:withRedirectURL:)]) {
                    [[class defaultManager] fnSocial_setAppKey:appKey withAppSecret:appSecret withRedirectURL:redirectURL];
                }
            }
        }
            break;
        case FNSocialPlatformType_Sina:
        {
            id class = NSClassFromString(@"FNSocialSinaHandler");
            if (class) {
                if ([[class defaultManager] respondsToSelector:@selector(fnSocial_setAppKey:withAppSecret:withRedirectURL:)]) {
                    [[class defaultManager] fnSocial_setAppKey:appKey withAppSecret:appSecret withRedirectURL:redirectURL];
                }
            }
        }
            break;
        case FNSocialPlatformType_WechatSession:
        case FNSocialPlatformType_WechatTimeLine:
        {
            id class = NSClassFromString(@"FNSocialWXHandler");
            if (class) {
                if ([[class defaultManager] respondsToSelector:@selector(fnSocial_setAppKey:withAppSecret:withRedirectURL:)]) {
                    [[class defaultManager] fnSocial_setAppKey:appKey withAppSecret:appSecret withRedirectURL:redirectURL];
                }
            }
        }
            break;
        default:
            break;
    }
    return NO;
}


#pragma mark -- share object
- (void)shareToPlatform:(FNSocialPlatformType)platformType messageObject:(FNSocialMessageObject *)messageObject currentViewController:(id)currentViewController completion:(FNSocialRequestCompletionHandler)completion
{
    self.platformType = platformType;
    NSString *description = messageObject.text;

    switch (platformType) {
        case FNSocialPlatformType_Sina:
        {
            id class = NSClassFromString(@"FNSocialSinaHandler");
            if (class) {
                [[class defaultManager] fnSocial_ShareWithObject:messageObject withViewController:currentViewController
                                              socialPlatformType:platformType withCompletionHandler:completion];
            }

        }
            break;
        case FNSocialPlatformType_QQ:
        case FNSocialPlatformType_Qzone:
        {

            id class = NSClassFromString(@"FNSocialQQHandler");
            if (class) {
                [[class defaultManager] fnSocial_ShareWithObject:messageObject withViewController:currentViewController
                 socialPlatformType:platformType withCompletionHandler:completion];
            }
        }
            break;
        case FNSocialPlatformType_WechatSession:
        case FNSocialPlatformType_WechatTimeLine:
        {
            id class = NSClassFromString(@"FNSocialWXHandler");
            if (class) {
                [[class defaultManager] fnSocial_ShareWithObject:messageObject withViewController:currentViewController
                                              socialPlatformType:platformType withCompletionHandler:completion];
            }

        }
            break;
        case FNSocialPlatformType_Sms:
        {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate =self;
            _messagePicker = picker;
            NSString *smsBody =[NSString stringWithFormat:@"%@",description];
            picker.body=smsBody;
            [currentViewController presentViewController:picker animated:YES completion:nil];
        }
        default:
            break;
    }
}

#pragma mark -- message callback
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultSent:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_Success);
        }
            break;
        case MessageComposeResultFailed:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_ShareFailed);
        }
            break;
        case MessageComposeResultCancelled:
        {
            self.completionHandler(@"",FNSocialPlatformResultType_Cancel);
        }
            break;
        default:
            break;
    }
    [_messagePicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma marl -- open url
- (BOOL)handleOpenURL:(NSURL *)url
{
    switch (self.platformType) {
        case FNSocialPlatformType_QQ:
        case FNSocialPlatformType_Qzone:
        {
            id class = NSClassFromString(@"FNSocialQQHandler");
            if (class) {
                return [[class defaultManager] fnSocial_handleOpenURL:url];
            }
            return NO;
        }
            break;
        case FNSocialPlatformType_WechatSession:
        case FNSocialPlatformType_WechatTimeLine:
        {
            id class = NSClassFromString(@"FNSocialWXHandler");
            if (class) {
                return [[class defaultManager] fnSocial_handleOpenURL:url];
            }
            return NO;
        }
            break;
        case FNSocialPlatformType_Sina:
        {
            id class = NSClassFromString(@"FNSocialSinaHandler");
            if (class) {
                return [[class defaultManager] fnSocial_handleOpenURL:url];
            }
            return NO;
        }
        default:
            return NO;
            break;
    }
    
}

+ (BOOL)isWXAppInstalled
{
    id class = NSClassFromString(@"FNSocialWXHandler");
    if (class) {
        return [[class defaultManager] isFNSocialWXAppInstalled];
    }
    return NO;
}

@end
