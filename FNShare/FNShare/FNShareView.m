//
//  FNShareView.m
//  ShareToUM
//
//  Created by zmx on 15/6/30.
//  Copyright (c) 2015年 zmx. All rights reserved.
//

#import "FNShareView.h"
#import "MBProgressHUD.h"
#import "shareCollectionViewCell.h"
#import "BFKit.h"

#import "FNSocialManager.h"
#import "FNSocialMessageObject.h"


#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

static NSString *shareCellIdentifier = @"shareCollectionViewCell";
static NSInteger const rowCount = 4;
static CGFloat const cancelButtonHeight = 56;
static CGFloat const topSpace = 5;
static CGFloat const bottomSpace = 49;
static CGFloat const collectHeight = 92;

@interface FNShareView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIImage *_shareImage;
    MBProgressHUD *HUD;
}
@property (nonatomic,copy   ) NSString                   *shareContents;
@property (nonatomic,copy   ) NSString                   *shareUrl;
@property (nonatomic,copy   ) NSString                   *shareTitle;
@property (nonatomic,copy   ) NSString                   *shareImg;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UICollectionView           *collectionView;
@property (nonatomic, strong) NSArray                    *shareArray;           //title：微信好友
@property (nonatomic, strong) NSArray                    *shareIconArray;       //icon
@property (nonatomic, assign) CGFloat                    height;                //collectionView高度
@property (nonatomic, strong) UIButton                   *cancleBtn;
@property (nonatomic, strong) UIView                     *blackBackgroundView;
@property (nonatomic, strong) UIView                     *twoDimensionView;
@property (nonatomic, assign) BOOL  isSinaShare;

@property (nonatomic ,copy) void (^result)(FNShareResponsetResult);
@end

@implementation FNShareView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
            _shareArray = [[NSArray alloc] initWithObjects:@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"复制链接",@"短信",@"新浪微博",nil];
            _shareIconArray = [[NSArray alloc] initWithObjects:@"share_weChart",@"share_circleOfFriends",@"share_qqfriends",@"share_qqzone",@"icon_copy-link",@"share_message",@"share_sina",nil];
            
            [self configureBackGroundBlackView];
            [self configureCollectionView];
            [self showCollectionView];
        }
    }
    return self;
}

- (void)shareToUMWithContent:(NSString *)shareContent title:(NSString *)shareTitle url:(NSString *)shareUrl image:(NSString *)shareImage
{
    self.shareContents = shareContent;
    self.shareTitle = shareTitle;
    self.shareImg = shareImage;
    self.shareUrl = shareUrl;
    [self shareToUMWithImage:shareImage];

}

- (void)cancleButtonClick:(UIButton *)sender
{

    [self hiddenCollectionView];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self hiddenCollectionView];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
}


#pragma mark CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shareArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    shareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellIdentifier forIndexPath:indexPath];
    cell.title.textColor = [UIColor colorWithHex:0x888888];
    cell.title.text = _shareArray[indexPath.row];
    cell.shareIcon.image = [UIImage imageNamed:_shareIconArray[indexPath.row]];
    cell.tag = indexPath.row+100;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Main_Screen_Width/rowCount, collectHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     switch (indexPath.row+100) {
        case 100://微信好友
        {
            if ([FNSocialManager isWXAppInstalled]) {

                FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
                [messageObject shareObjectWithTitle:self.shareTitle descr:self.shareContents thumImage:self.shareImg webPageUrl:self.shareUrl];
                
                [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_WechatSession messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                    if (errorCode != FNSocialPlatformResultType_Success) {
                        [self showHUDWithText:@"分享取消"];
                    }else{
                        [self showHUDWithText:@"分享成功"];
                    }
                }];

            }else{
                [self showHUDWithText:@"您未安装微信,无法分享"];
            }
            
            [self hiddenCollectionView];
        }
            break;
        case 101://微信朋友圈
        {
            if ([FNSocialManager isWXAppInstalled]) {

                FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
                [messageObject shareObjectWithTitle:self.shareTitle descr:self.shareContents thumImage:self.shareImg webPageUrl:self.shareUrl];
                
                [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                    if (errorCode != FNSocialPlatformResultType_Success) {
                        [self showHUDWithText:@"分享取消"];
                    }else{
                        [self showHUDWithText:@"分享成功"];
                    }
                }];

            }else{
                [self showHUDWithText:@"您未安装微信,无法分享"];
            }
            

            [self hiddenCollectionView];
        }
            break;
        case 102://qq
        {
            FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
            [messageObject shareObjectWithTitle:self.shareTitle descr:self.shareContents thumImage:self.shareImg webPageUrl:self.shareUrl];
            
            [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_QQ messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                if (errorCode != FNSocialPlatformResultType_Success) {
                    [self showHUDWithText:@"分享取消"];
                }else{
                    [self showHUDWithText:@"分享成功"];
                }
            }];
            
            [self hiddenCollectionView];
        }
            break;
        case 103://qq空间
        {
            FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
            [messageObject shareObjectWithTitle:self.shareTitle descr:self.shareContents thumImage:self.shareImg webPageUrl:self.shareUrl];
            
            [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_Qzone messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                if (errorCode != FNSocialPlatformResultType_Success) {
                    [self showHUDWithText:@"分享取消"];
                }else{
                    [self showHUDWithText:@"分享成功"];
                }
            }];

            [self hiddenCollectionView];
        }
            break;
         case 104://复制链接
         {
             NSString *content;
             if (!self.isNeedTitle) {
                 content = [NSString stringWithFormat:@"%@%@",self.shareContents,self.shareUrl];
             }else{
                 content = [NSString stringWithFormat:@"%@,%@%@",self.shareTitle,self.shareContents,self.shareUrl];
             }
             NSString *string  = content;
             UIPasteboard *pab = [UIPasteboard generalPasteboard];
             [pab setString:string];
             if (pab == nil) {
                 //                [self showHUDWithText:@"复制失败"];
             }else{
                 [self showHUDWithText:@"复制成功"];
             }
             [self hiddenCollectionView];
         }
             break;

        case 105://短信
        {
            NSString *content;
            if (!self.isNeedTitle) {
                content = [NSString stringWithFormat:@"%@%@",self.shareContents,self.shareUrl];
            }else{
                content = [NSString stringWithFormat:@"%@,%@%@",self.shareTitle,self.shareContents,self.shareUrl];
            }
            FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
            [messageObject shareObjectWithTitle:self.shareTitle descr:content thumImage:self.shareImg webPageUrl:self.shareUrl];
            [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_Sms messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                if (errorCode != FNSocialPlatformResultType_Success) {
                    [self showHUDWithText:@"分享取消"];
                }else{
                    [self showHUDWithText:@"分享成功"];
                }
            }];

            [self hiddenCollectionView];
        }
            break;
         case 106://微博分享
         {
             NSString *content;
             if (!self.isNeedTitle) {
                 content = [NSString stringWithFormat:@"%@%@%@",self.shareContents,self.shareUrl,@"|下载飞牛网APP查看更多商品:http://m.feiniu.com/download/index @飞牛网微博"];
             }else{
                 content = [NSString stringWithFormat:@"%@,%@%@%@",self.shareTitle,self.shareContents,self.shareUrl,@"|下载飞牛网APP查看更多商品:http://m.feiniu.com/download/index @飞牛网微博"];
             }
             FNSocialMessageObject *messageObject = [FNSocialMessageObject messageObject];
             [messageObject shareObjectWithTitle:self.shareTitle descr:content thumImage:_shareImage webPageUrl:self.shareUrl];
             [[FNSocialManager defaultManager]shareToPlatform:FNSocialPlatformType_Sina messageObject:messageObject currentViewController:_shareViewController completion:^(id result, NSInteger errorCode) {
                 if (errorCode != FNSocialPlatformResultType_Success) {
                     [self showHUDWithText:@"分享取消"];
                 }else{
                     [self showHUDWithText:@"分享成功"];
                 }
             }];
             [self hiddenCollectionView];
         }
             break;
        default:
            break;
    }
}


#pragma mark -- UI

- (void)configureBackGroundBlackView
{
    self.blackBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.blackBackgroundView.backgroundColor = [UIColor blackColor];
    self.blackBackgroundView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.blackBackgroundView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.blackBackgroundView addGestureRecognizer:pan];
    [self addSubview:self.blackBackgroundView];
}

- (void)configureCollectionView
{
    NSInteger row = _shareArray.count%rowCount>0?1:0;
    _height = (_shareArray.count/rowCount+row)*collectHeight+cancelButtonHeight+topSpace+bottomSpace;
    _collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView.collectionViewLayout = _collectionFlowLayout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, _height) collectionViewLayout:_collectionFlowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(topSpace, 0, 0 , 0 );
    self.collectionFlowLayout.minimumInteritemSpacing = 0;
    self.collectionFlowLayout.minimumLineSpacing = 0;
    _collectionView.backgroundColor = [UIColor colorWithHex:0xf9f9f9];
    [self addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:shareCellIdentifier bundle:nil] forCellWithReuseIdentifier:shareCellIdentifier];
    
    [self configureCancaleButton];
}

- (void)configureCancaleButton
{
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(0, _height-cancelButtonHeight, Main_Screen_Width, cancelButtonHeight);
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_cancleBtn addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_collectionView addSubview:_cancleBtn];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, .5)];
    lineView.backgroundColor = [UIColor colorWithHex:0xd5d5d5];
    [_cancleBtn addSubview:lineView];
}


- (void)showCollectionView
{
    [self.blackBackgroundView setFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    
    [UIView animateWithDuration:.25 animations:^{
        self.blackBackgroundView.alpha = 0.5;
        [self.collectionView setFrame:CGRectMake(0, Main_Screen_Height-self.height, Main_Screen_Width, self.height)];
    } completion:^(BOOL finished) {
    }];
}

- (void)hiddenCollectionView
{
    [self.collectionView setFrame:CGRectMake(0, Main_Screen_Height-_height, Main_Screen_Width, _height)];
    
    [UIView animateWithDuration:.25 animations:^{
        self.blackBackgroundView.alpha = 0;
        [self.collectionView setFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, self.height)];
    } completion:^(BOOL finished) {
        [self.collectionView removeFromSuperview];
        [self.blackBackgroundView removeFromSuperview];
        [self.twoDimensionView removeFromSuperview];
        [self removeFromSuperview];
        self.collectionView = nil;
        self.blackBackgroundView = nil;
        self.cancleBtn = nil;
    }];
}

- (void)shareToUMWithImage:(NSString *)image
{
    _shareImage        = [[UIImage alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url         = [NSURL URLWithString:image];
        NSData *resultData = [NSData dataWithContentsOfURL:url];
        UIImage *img       = [UIImage imageWithData:resultData];
        _shareImage        = img;
    });
}

- (void)showHUDWithText:(NSString *)labelText
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.shareViewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = labelText;
    //    hud.margin = 15.f;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


@end
