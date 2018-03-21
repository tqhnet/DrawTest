//
//  CanvasView.h
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 类：画布视图
 简单涂鸦版原理：
 1.使用draw绘图
 2.直接调用UIView里面的触碰事件
 3.触碰开始的时候创建路径，将路径和参数装进数组中
 4.移动的时候将移动的线条添加到路径上，并刷新draw
 5.结束的时候消除路径
 6.可操控数组里面的元素进行撤销，清空等
 */

@interface CanvasView : UIView
{
    CGPoint _start;          //起始点
    CGPoint _move;           //移动电
    CGMutablePathRef _path;  //路径
    CGFloat _lineWidth;      //线宽度
    BOOL _isDrawLine;        //是否有画线
    UIColor *_lineColor;     //线条颜色
}

@property (nonatomic,strong) NSMutableArray *pathArray;

//储存照片
- (void)savePhotoToAlbum;
//撤销
- (void)undoLastDraw;
//清空画布
- (void)clearDrawBoard;
@end
