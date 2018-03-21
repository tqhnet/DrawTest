//
//  ViewController.m
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "CanvasView.h"
#import "CavansBezierPathView.h"
#import "CavansMosaicView.h"

@interface ViewController ()

@property (nonatomic,strong) CanvasView *canvas;                    //画布
@property (nonatomic,strong) CavansBezierPathView *canvasBezier;    //画布2
@property (nonatomic,strong) CavansMosaicView *mosaicView;          //马赛克视图

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.canvas];
    [self.view addSubview:self.mosaicView];
}


- (CanvasView *)canvas {
    if (!_canvas) {
        _canvas = [[CanvasView alloc]initWithFrame:self.view.bounds];
    }
    return _canvas;
}

- (CavansBezierPathView *)canvasBezier {
    if (!_canvasBezier) {
        _canvasBezier = [[CavansBezierPathView alloc]initWithFrame:self.view.bounds];
    }
    return _canvasBezier;
}

- (CavansMosaicView *)mosaicView {
    if (!_mosaicView) {
        _mosaicView = [[CavansMosaicView alloc]initWithFrame:self.view.bounds];
    }
    return _mosaicView;
}

@end
