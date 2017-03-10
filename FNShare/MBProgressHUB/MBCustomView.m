//
//  MBCustomView.m
//  HudDemo
//
//  Created by EasonFeng on 4/17/15.
//  Copyright (c) 2015 Matej Bukovinski. All rights reserved.
//

#import "MBCustomView.h"
#import <QuartzCore/QuartzCore.h>


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface MBCustomView()

@property (nonatomic, weak) CALayer *circleLayer;

@end
@implementation MBCustomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CALayer *titleLayer = [CALayer new];
        [titleLayer setFrame:self.bounds];
        [titleLayer setContents:(__bridge id)[UIImage imageNamed:@"loading_fn"].CGImage];
        titleLayer.contentsGravity = kCAGravityResizeAspect;
        titleLayer.contentsScale =[UIScreen mainScreen].scale;
        
        CALayer *circleLayer = [CALayer new];
        [circleLayer setFrame:self.bounds];
        [circleLayer setContents:(__bridge id)[UIImage imageNamed:@"loading_Circle"].CGImage];
        circleLayer.contentsGravity = kCAGravityResizeAspect;
        circleLayer.contentsScale =[UIScreen mainScreen].scale;
        self.circleLayer = circleLayer;
        [self.layer addSublayer:titleLayer];
        [self.layer addSublayer:circleLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addAnimation];
}

- (void)addAnimation
{
    [self.circleLayer removeAllAnimations];
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    
    animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(DEGREES_TO_RADIANS(0), 0, 0, 1.0) ];
    
    animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(DEGREES_TO_RADIANS(-270), 0, 0, 1.0) ];
    
    animation.duration = 0.2;
    animation.cumulative = YES;
    animation.repeatCount = FLT_MAX;
    [self.circleLayer addAnimation: animation forKey: @"animation" ];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
