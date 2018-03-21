//
//  CustomPath.h
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

/**路径类，其实和之前的字典差不多*/
@interface CustomPath : NSObject

@property (nonatomic, strong) UIColor *pathColor;//画笔颜色
@property (nonatomic, assign) CGFloat lineWidth;//线宽
@property (nonatomic, assign) BOOL isEraser;//橡皮擦
@property (nonatomic, copy) NSString *imagePath;//图片路径
@property (nonatomic, strong) UIBezierPath *bezierPath;

//创建路径对象
+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isEraser:(BOOL)isEraser;

//绘制路径，可以添加圆矩形，橡皮等
- (void)pathLineToPoint:(CGPoint)movePoint;


@end
