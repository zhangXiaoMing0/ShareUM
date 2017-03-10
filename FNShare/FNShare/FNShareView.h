//
//  FNShareView.h
//  ShareToUM
//
//  Created by zmx on 15/6/30.
//  Copyright (c) 2015年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FNShareResponsetResult){
    FNShareResponseSuccess,
    FNShareResponseFaild,
    FNShareResponseCancel,
    FNShareResponseNotInstall   //未安装客户端
};

typedef NS_ENUM(NSInteger,FNShareToType){
    FNShareToWechatTimeline = 1,
    FNShareToWechatFriend,
    FNShareToQQ,
    FNShareToSina,
    FNShareToQQZone,
    FNShareToMessage
};


@interface FNShareView : UIView

@property (nonatomic,weak) UIViewController *shareViewController;

@property (nonatomic,assign) BOOL isNeedTitle;

- (void)shareToUMWithContent:(NSString *)shareContent title:(NSString *)shareTitle url:(NSString *)shareUrl image:(NSString *)shareImage;


@end
