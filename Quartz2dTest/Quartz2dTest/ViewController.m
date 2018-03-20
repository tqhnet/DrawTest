//
//  ViewController.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "DrawTestView.h"
#import "DrawTestView2.h"
#import "DrawCircularProgressView.h"
#import "DrawSnowflakesFlutteringView.h"

@interface ViewController (){
    //滤镜相关
    UIImagePickerController *_imagePickerController;//系统照片选择控制器
    UIImageView *_imageView;//图片显示控件
    CIContext *_context;//core image上下文
    CIImage *_image;//编辑图像
    CIImage *_outputImage;//输出图像
    CIFilter *_colorControlsFilter;//色彩滤镜
}

//绘图相关
@property (nonatomic,strong) DrawTestView *drawView;
@property (nonatomic,strong) DrawTestView2 *drawView2;
@property (nonatomic,strong) DrawCircularProgressView *progressView;
@property (nonatomic,strong) DrawSnowflakesFlutteringView *snowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.drawView];
    [self.view addSubview:self.drawView2];
    
//    [self.drawView2 drawContentToPdfContext];
    [self initLayout];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.snowView];

}

- (DrawTestView *)drawView {
    if (!_drawView) {
        _drawView = [[DrawTestView alloc]initWithFrame:self.view.bounds];
    }
    return _drawView;
}

- (DrawTestView2 *)drawView2 {
    if (!_drawView2) {
        _drawView2 = [[DrawTestView2 alloc]initWithFrame:self.view.bounds];
    }
    return _drawView2;
}

- (DrawCircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DrawCircularProgressView alloc]initWithFrame:CGRectMake(0, 50, 100, 100)];
        _progressView.progressValue = 0.5;
    }
    return _progressView;
}

- (DrawSnowflakesFlutteringView *)snowView {
    if (!_snowView) {
        _snowView = [[DrawSnowflakesFlutteringView alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    }
    return _snowView;
}

#pragma mark - 滤镜方面
- (void)initLayout {
    [self showAllFilters];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    //_imageView.image = [UIImage imageNamed:@"test.jpg"];
    [self.view addSubview:_imageView];
    
    /**
     1.创建图像上下文CIContext
     
     2.创建滤镜CIFilter
     
     3.创建过滤原图片CIImage
     
     4.调用CIFilter的setValue： forKey：方法为滤镜指定源图片
     
     5.设置滤镜参数【可选】
     
     6.取得输出图片显示或保存
     */
    _context = [CIContext contextWithOptions:nil];
    //取得滤镜
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    //初始化CIImage源图像
    _image = [CIImage imageWithCGImage:[UIImage imageNamed:@"test.jpg"].CGImage];
    [_colorControlsFilter setValue:_image forKey:@"inputImage"];//设置滤镜的输入图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self changeStaturation:0.4];
        [self changeBrightness:0.2];
//        [self changeContrast:0.4];
    
    });
 
}

/**将输出图片设置到UIImageView*/
-(void)setImage{
    CIImage *outputImage = [_colorControlsFilter outputImage];//取得输出图像
    CGImageRef temp = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    _imageView.image = [UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    
    CGImageRelease(temp);//释放CGImage对象
}

/***/
-(void)changeStaturation:(CGFloat)f{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:f] forKey:@"inputSaturation"];//设置滤镜参数
    [self setImage];
}

#pragma mark 调整亮度
-(void)changeBrightness:(CGFloat)f{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:f] forKey:@"inputBrightness"];
    [self setImage];
}

#pragma mark 调整对比度
-(void)changeContrast:(CGFloat)f{
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:f] forKey:@"inputContrast"];
    [self setImage];
}


#pragma mark 查看所有内置滤镜
-(void)showAllFilters{
    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    for (NSString *filterName in filterNames) {
        CIFilter *filter=[CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
    }
}

@end
