//
//  FNSocialMessageObject.h
//  FNMarket
//
//  Created by zmx on 2017/2/22.
//  Copyright © 2017年 cn.com.feiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNSocialMessageObject : NSObject

/**
 *  文本标题
 *  @discuss 该字段以后会在需要文本title字段中扩展。
 */
@property (nonatomic,copy)NSString* title;

/**
 * text 文本内容
 * @note 非纯文本分享文本描述文字
 */
@property (nonatomic, copy) NSString  *text;

/** 网页的url地址
 *
 */
@property (nonatomic, retain) NSString *webpageUrl;

/** 图片的url地址
 *
 */
@property (nonatomic, strong) id previewImageUrl;


/**
 

 @param title 标题
 @param descr 描述
 @param thumImage 图片url
 @return self
 */
- (FNSocialMessageObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumImage:(id)thumImage
                                  webPageUrl:(NSString *)webPageUrl;

+ (FNSocialMessageObject *)messageObject;

@end
