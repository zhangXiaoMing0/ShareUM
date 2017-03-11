# ShareUM
仿照友盟目录结构对微信 QQ 微博分享的SDK进行封装，具有热插拔的功能，需要哪个分享导入哪个文件夹

##分享前配置添加SDK依赖的系统库文件

在Xcode中打开工程配置文件，选择“summary”一栏。在“summary”中选择“Linked Frameworks and Libraries”一栏，点击“+”图标添加下面八个库文件，分别是  
      Security.framework  
    libiconv.dylib  
    SystemConfiguration.framework  
    CoreGraphics.Framework  
    libsqlite3.dylib  
    CoreTelephony.framework  
    libstdc++.dylib  
    libz.dylib  

##配置URL schemes

在你的工程设置项,targets 一栏下,选中自己的 target,在 Info->URL Types 中添加 URL Schemes,添加xcode的url scheme


##设置白名单
目前分享必须设置白名单，不设置是无法跳转到相应分享平台
```
    <key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wechat</string>
		<string>weixin</string>
		<string>sinaweibohd</string>
		<string>sinaweibo</string>
		<string>sinaweibosso</string>
		<string>weibosdk</string>
		<string>weibosdk2.5</string>
		<string>mqqapi</string>
		<string>mqq</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqconnect</string>
		<string>mqqopensdkdataline</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkapi</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV3</string>
		<string>alipass</string>
		<string>alipays</string>
		<string>alipayqr</string>
		<string>alipay</string>
		<string>alipaywifi</string>
		<string>alipayfreewifi</string>
		<string>alipayauth</string>
		<string>aliminipayauth</string>
		<string>alipaywifimcd</string>
		<string>alipayre</string>
		<string>alipaysso</string>
		<string>alipayshare</string>
		<string>uppaysdk</string>
		<string>uppaywallet</string>
		<string>uppayx1</string>
		<string>uppayx2</string>
		<string>uppayx3</string>
	</array>
```

##代码实现

###在AppDelegate内设置AppKey

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FNUMShare configureUMShare];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[FNSocialManager defaultManager] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FNSocialManager defaultManager] handleOpenURL:url];
}
```
### 分享设置平台key和分享方法

#### FNSocialManager.h

```
/**
 *  设置平台的appkey
 *
 *  @param platformType 平台类型 @see FNSocialPlatformType
 *  @param appKey       第三方平台的appKey（QQ平台为appID）
 *  @param appSecret    第三方平台的appSecret（QQ平台为appKey）
 *  @param redirectURL  redirectURL
 */
- (BOOL)setPlaform:(FNSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;


/**
 *  设置分享平台
 *
 *  @param platformType  平台类型 @see FNSocialPlatformType
 *  @param messageObject  分享的content @see FNSocialMessageObject
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 *  @discuss currentViewController 只正对sms,email等平台需要传入viewcontroller的平台，其他不需要的平台可以传入nil
 */
- (void)shareToPlatform:(FNSocialPlatformType)platformType
          messageObject:(FNSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(FNSocialRequestCompletionHandler)completion;
```
#### FNSocialManager.m
实现代码中无需导入FNSocialHandler.h子类文件通过  
`id class = NSClassFromString(@"FNSocialQQHandler");`得到相应的类，减少耦合性

```
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
```

###调用实现方法
分享点击事件
```
- (void)buttonClick
{
    FNShareView *sharesView = [[FNShareView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    sharesView.shareViewController = self;
    sharesView.isNeedTitle = YES;
    [sharesView shareToUMWithContent:@"MX的活动太给力了！我去抢了，别说我没告诉你啊~" title:@"小明秒杀-每天多档底价好货限时限量秒" url:@"https://sports.qq.com/a/20120510/000650.htm" image:@"https://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    [self.view addSubview:sharesView];

}
```



