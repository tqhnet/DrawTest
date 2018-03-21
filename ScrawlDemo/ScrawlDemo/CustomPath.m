//
//  CustomPath.m
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "CustomPath.h"

@interface CustomPath ()

@property (nonatomic, assign) CGPoint beginPoint;   //起始点
@property (nonatomic, assign) CGFloat pathWidth;    //线宽

@end
@implementation CustomPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isEraser:(BOOL)isEraser
{
    CustomPath *path = [[CustomPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth = pathWidth;
    path.isEraser = isEraser;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = pathWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    path.bezierPath = bezierPath;
    
    return path;
}

- (void)pathLineToPoint:(CGPoint)movePoint {
    
    [self.bezierPath addLineToPoint:movePoint];
}

@end
