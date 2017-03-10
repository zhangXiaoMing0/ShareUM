//
//  ViewController.m
//  FNShare
//
//  Created by zmx on 2017/3/7.
//  Copyright © 2017年 zmx. All rights reserved.
//

#import "ViewController.h"
#import "FNShareView.h"

#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(0, 100, Main_Screen_Width, 50);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"share" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick
{
    FNShareView *sharesView = [[FNShareView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    sharesView.shareViewController = self;
    sharesView.isNeedTitle = YES;
    [sharesView shareToUMWithContent:@"MX的活动太给力了！我去抢了，别说我没告诉你啊~" title:@"小明秒杀-每天多档底价好货限时限量秒" url:@"https://sports.qq.com/a/20120510/000650.htm" image:@"https://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
    [self.view addSubview:sharesView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
