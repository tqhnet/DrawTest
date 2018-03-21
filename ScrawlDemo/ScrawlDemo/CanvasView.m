//
//  CanvasView.m
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _start = CGPointMake(0, 0);
        _move = CGPointMake(0, 0);
        _lineWidth = 5;
        _lineColor = [UIColor blackColor];
        _pathArray = [NSMutableArray array];
        _isDrawLine = NO;
        self.backgroundColor = [UIColor whiteColor];
        
//        NSInteger haha = 12;
//        NSString *str = @" whaha";
//        NSMutableString *mutables = [[NSMutableString alloc]initWithString:@"mutable"];
//        NSDictionary *dic = @{@"haha":@(haha),@"str":str,@"mutables":mutables};
//        haha = 13;
//        str = @"ssssss";
//        [mutables appendString:@"123"];
//        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            NSLog(@"%@",obj);
//        }];
    }
    return self;
}


#pragma mark - public

/**
 *  保存图像至相册
 */
-(void)savePhotoToAlbum
{
    if (_pathArray.count) {
        
        UIGraphicsBeginImageContext(self.frame.size);//创建一个基于位图的上下文，并设置当前上下文
        CGContextRef contex = UIGraphicsGetCurrentContext();//获取图形上下文
        UIRectClip(CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30));
        [self.layer renderInContext:contex];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        
    }
}

/**
 *  撤销上一次操作
 */
-(void)undoLastDraw
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

/**
 *  清空画板
 */
-(void)clearDrawBoard
{
    _isDrawLine = NO;
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

/**橡皮*/

#pragma mark - private

//绘图
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //涂鸦
    [self scrawl:context];
}

- (void)scrawl:(CGContextRef)context {
    //有线条才进行绘制
    if (self.pathArray.count) {
        //遍历数组进行绘制，感觉效率不是很高哎
        [self.pathArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull attribute, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPathRef pathRef = (__bridge CGPathRef)attribute[@"path"];
            CGContextAddPath(context, pathRef);
            //设置上下文属性
            [attribute[@"color"] setStroke];//设置边框颜色
            CGContextSetLineWidth(context, [attribute[@"width"] floatValue]);
            //绘制线条
            CGContextDrawPath(context, kCGPathStroke);
        }];
    }
}

#pragma mark - 触碰监听

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //获取单个触碰和坐标
    UITouch * touch = [touches anyObject];
    
    //创建路径
    _path = CGPathCreateMutable();
    
    //__bridge id 显示转换，由于路径是可变的，所以传入之后也能进行改变，即使它的容器本身是不可变的
    //所以从容器中取值的时候也最好都用copy创建一个新的对象
    NSDictionary *attribute = @{@"path":(__bridge id)(_path),@"color":_lineColor,@"width":@(_lineWidth)};
    [_pathArray addObject:attribute];//路径及属性数组
    
    _start = [touch locationInView:self];//起始点
    
    CGPathMoveToPoint(_path, NULL, _start.x, _start.y);//将画笔移动到某点
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //释放路径
    CGPathRelease(_path);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [touches anyObject];
    _move = [touch locationInView:self];
    
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    [self setNeedsDisplay];//自动调用drawRect:(CGRect)rect
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
