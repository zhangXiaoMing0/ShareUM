//
//  FNSocialMessageObject.m
//  FNMarket
//
//  Created by zmx on 2017/2/22.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import "FNSocialMessageObject.h"

@implementation FNSocialMessageObject

+ (FNSocialMessageObject *)messageObject
{
    static FNSocialMessageObject *socialMessage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        socialMessage = [[FNSocialMessageObject alloc] init];
    });
    return socialMessage;
}

- (FNSocialMessageObject *)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage webPageUrl:(NSString *)webPageUrl
{
    _title = title;
    _text = descr;
    _previewImageUrl = thumImage;
    _webpageUrl = webPageUrl;
    return self;
}

@end
