//
//  TTMWebImageProgressLineView.m
//  TTMWebImage
//
//  Created by lzb on 3/8/17.
//  Copyright © 2017 lzb. All rights reserved.
//

#import "TTMWebImageProgressLineView.h"


@interface TTMWebImageProgressLineView ()
@property (nonatomic, weak) CAShapeLayer *lineLayer;
@end

@implementation TTMWebImageProgressLineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)lineLayer
{
    return (CAShapeLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect
{
    // 预设常量
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat midHeight = CGRectGetMidY(rect);
    
    CAShapeLayer *layer = self.lineLayer;
    
    [UIView performWithoutAnimation:^{
        // 绘制背景
        layer.cornerRadius = midHeight;
        
        // 绘制进度条
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, midHeight)];
        [path addLineToPoint:CGPointMake(width, midHeight)];
        layer.lineWidth = height;
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor colorWithRed:70.0/255.0
                                            green:210.0/255.0
                                             blue:100.0/255.0
                                            alpha:1].CGColor;
        layer.lineCap = kCALineCapRound;
        layer.strokeStart = 0;
    }];
    
    layer.strokeEnd = self.progress;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0) {
        _progress = 0;
        self.lineLayer.strokeEnd = 0;
        [self setNeedsDisplay];
        return;
    }
    
    if (progress > 1) {
        _progress = 1;
        self.lineLayer.strokeEnd = 1;
        [self setNeedsDisplay];
        return;
    }
    
    _progress = progress;
    self.lineLayer.strokeEnd = _progress;
    [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 8);
}

@end
