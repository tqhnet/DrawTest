//
//  DrawCircularProgressView.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "DrawCircularProgressView.h"

@implementation DrawCircularProgressView

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat radius = self.frame.size.height * 0.5 - 10;
    CGFloat endA = self.progressValue*M_PI*2 - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius+5,radius+5) radius:radius-5 startAngle:-M_PI_2 endAngle:endA clockwise:YES];
    
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor redColor] set];
    [path stroke];
    
}


@end
