//
//  ViewController.m
//  FilterTestDemo
//
//  Created by tqh on 2018/3/26.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "CPUImageFilterUtil.h"
#import "FWApplyFilter.h"
#import <CoreImage/CoreImage.h>
@interface ViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    
    
    
    //系统自带，颜色矩阵混合
//    UIImage *image = [CPUImageFilterUtil imageWithImage:[UIImage imageNamed:@"test.jpg"] withColorMatrix:colormatrix_gete];
    
    //自定义滤镜类
//    UIImage *image = [FWApplyFilter applyLomofiFilter:[UIImage imageNamed:@"test.jpg"]];
    
    //shader文件
//    UIImage *image = [FWApplyFilter customfilter:@"test" image:[UIImage imageNamed:@"test.jpg"]];
    
    //LUT形式
//    UIImage *image = [FWApplyFilter snapchatFilter:[UIImage imageNamed:@"test.jpg"]];
    
    //glsl文件形式
    UIImage *image = [FWApplyFilter qmfilter:[UIImage imageNamed:@"test.jpg"] index:2];
    self.imageView.image = image;
   
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = self.view.bounds;
        _imageView.image = [UIImage imageNamed:@"test.jpg"];
    }
    return _imageView;
    
}
@end
