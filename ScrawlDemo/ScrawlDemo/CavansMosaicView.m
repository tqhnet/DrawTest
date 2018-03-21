//
//  CavansMosaicView.m
//  ScrawlDemo
//
//  Created by tqh on 2018/3/21.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "CavansMosaicView.h"
#import "UIImage+IJSUImage.h"

@interface CavansMosaicView (){
    CGMutablePathRef _path;
}

@property (nonatomic,strong) UIImageView *surfaceImageView; //底层图片
@property (nonatomic,strong) CALayer *imageLayer;           //处理过的图片
@property (nonatomic,strong) CAShapeLayer *shapeLayer;      //画笔蒙版
@property (nonatomic,strong) NSMutableArray *pathArray;     //单条路径

@end

@implementation CavansMosaicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.surfaceImageView];
        [self.layer addSublayer:self.imageLayer];
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        self.imageLayer.contents = (id)[self gaussianBlurImage].CGImage; // 设置底层的图片,layer的图片都是存在 contents
//        self.imageLayer.contents = (id)[self mosaicImage].CGImage; // 设置底层的图片,layer的图片都是存在 contents
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@",self.pathArray);
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //创建单个路径
    _path = CGPathCreateMutable();
    //创建初始路径
    CGPathMoveToPoint(_path, NULL, point.x, point.y);
    [self.pathArray addObject:(__bridge id)(_path)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //移动路径
    CGPathAddLineToPoint(_path, NULL, point.x, point.y);
    [self drawMosaic];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPathRelease(_path);
}

//绘制马赛克
- (void)drawMosaic {

    //绘制总路径，将单个路径拼接
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < self.pathArray.count; i ++) {
        CGMutablePathRef path1 =(__bridge CGMutablePathRef) self.pathArray[i];
        //连接路径
        CGPathAddPath(path, NULL, path1);
    }
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

#pragma mark - 懒加载

- (UIImageView *)surfaceImageView {
    if (!_surfaceImageView) {
        _surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _surfaceImageView.image = [UIImage imageNamed:@"test.jpg"];
    }
    return _surfaceImageView;
}

- (CALayer *)imageLayer {
    if (!_imageLayer) {
        _imageLayer = [CALayer layer];
        _imageLayer.frame = self.bounds;
    }
    return _imageLayer;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        //手指移动时 画笔的宽度
        _shapeLayer.lineWidth = 30.f;
        _shapeLayer.strokeColor = [UIColor blueColor].CGColor; //不可设置clean
        _shapeLayer.fillColor = nil;
    }
    return _shapeLayer;
}

- (NSMutableArray *)pathArray {
    if (!_pathArray) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (UIImage *)mosaicImage {
    
    UIImage *showImage = [self.surfaceImageView.image getMosaicImageFromOrginImageBlockLevel:10];
    return showImage;
}

- (UIImage *)gaussianBlurImage {
    UIImage *showImage = [self.surfaceImageView.image getImageFilterForGaussianBlur:10];
    return showImage;
}

@end
