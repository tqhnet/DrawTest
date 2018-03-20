//
//  DrawPieChartView.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "DrawPieChartView.h"

@implementation DrawPieChartView

-(NSInteger )total{
    if (_total == 0) {
        for (int j = 0; j < self.nums.count; j++) {
            _total += [self.nums[j] integerValue];
        }
    }
    return _total;
}

-(NSArray *)nums{
    if (!_nums) {
        _nums = @[@23,@34,@33,@13,@30,@44,@66];
    }
    return _nums;
}

//只有在drawRect方法中才能拿到图形上下文，才可以画图
- (void)drawRect:(CGRect)rect {
    
    //绘制一个饼状图
    CGFloat centX = 100;
    CGFloat centY = 100;
    CGPoint center = CGPointMake(centX, centY);
    CGFloat radius = 50;
    CGFloat startA = 0;
    CGFloat endA = 0;
    
    for (int i = 0; i < self.nums.count; i++) {
        NSNumber *data = self.nums[i];
        startA = endA;
        endA = startA + [data floatValue]/self.total * 2 * M_PI;
        UIBezierPath *path  = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        [path addLineToPoint:center];
        
        CGFloat randRed = arc4random_uniform(256)/255.0;
        CGFloat randGreen = arc4random_uniform(256)/255.0;
        CGFloat randBlue = arc4random_uniform(256)/255.0;
        
        UIColor *randomColor = [UIColor colorWithRed:randRed green:randGreen blue:randBlue alpha:1.0];
        [randomColor set];
        [path fill];
    }
    
}

@end
