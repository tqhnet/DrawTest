//
//  FWCommonFilter.h
//  FWMeituApp
//
//  Created by ForrestWoo on 15-10-2.
//  Copyright (c) 2015年 ForrestWoo co,.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWApplyFilter : NSObject

//亮度
+ (UIImage *)changeValueForBrightnessFilter:(float)value image:(UIImage *)image;

//对比度
+ (UIImage *)changeValueForContrastFilter:(float)value image:(UIImage *)image;

//饱和度
+ (UIImage *)changeValueForSaturationFilter:(float)value image:(UIImage *)image;

//高光
+ (UIImage *)changeValueForHightlightFilter:(float)value image:(UIImage *)image;

//暗部
+ (UIImage *)changeValueForLowlightFilter:(float)value image:(UIImage *)image;

//智能补光
+ (UIImage *)changeValueForExposureFilter:(float)value image:(UIImage *)image;

//色温
+ (UIImage *)changeValueForWhiteBalanceFilter:(float)value image:(UIImage *)image;

//自然饱和度
+ (UIImage *)changeValueForVibranceFilter:(float)value image:(UIImage *)image;

//锐化
+ (UIImage *)changeValueForSharpenilter:(float)value image:(UIImage *)image;

//智能优化
+ (UIImage *)autoBeautyFilter:(UIImage *)image;

//风景
+ (UIImage *)applyViewFilter:(UIImage *)image;

//复杂滤镜

+ (UIImage *)applyStaticFilter:(UIImage *)image;

+ (UIImage *)applyAmatorkaFilter:(UIImage *)image;

+ (UIImage *)applyMissetikateFilter:(UIImage *)image;

+ (UIImage *)applySoftEleganceFilter:(UIImage *)image;

+ (UIImage *)applyNashvilleFilter:(UIImage *)image;

+ (UIImage *)applyLordKelvinFilter:(UIImage *)image;

+ (UIImage *)applyAmaroFilter:(UIImage *)image;

+ (UIImage *)applyRiseFilter:(UIImage *)image;

+ (UIImage *)applyHudsonFilter:(UIImage *)image;

+ (UIImage *)applyXproIIFilter:(UIImage *)image;

+ (UIImage *)apply1977Filter:(UIImage *)image;

+ (UIImage *)applyValenciaFilter:(UIImage *)image;

+ (UIImage *)applyWaldenFilter:(UIImage *)image;

+ (UIImage *)applyLomofiFilter:(UIImage *)image;

+ (UIImage *)applyLomo1Filter:(UIImage *)image;


+ (UIImage *)applyInkwellFilter:(UIImage *)image;

+ (UIImage *)applySierraFilter:(UIImage *)image;

+ (UIImage *)applyEarlybirdFilter:(UIImage *)image;

+ (UIImage *)applySutroFilter:(UIImage *)image;

+ (UIImage *)applyToasterFilter:(UIImage *)image;

+ (UIImage *)applyBrannanFilter:(UIImage *)image;

+ (UIImage *)applyHefeFilter:(UIImage *)image;

+ (UIImage *)applyGlassFilter:(UIImage *)image;

//模糊效果
+ (UIImage *)applyBoxBlur:(UIImage *)image;

+ (UIImage *)applyGaussianBlur:(UIImage *)image;
+ (UIImage *)applyGaussianSelectiveBlur:(UIImage *)image;
+ (UIImage *)applyiOSBlur:(UIImage *)image;
+ (UIImage *)applyMotionBlur:(UIImage *)image;
+ (UIImage *)applyZoomBlur:(UIImage *)image;
+ (UIImage *)applyColorInvertFilter:(UIImage *)image;
+ (UIImage *)applySepiaFilter:(UIImage *)image;
+ (UIImage *)applyHistogramFilter:(UIImage *)image;
+ (UIImage *)applyRGBFilter:(UIImage *)image;
+ (UIImage *)applyToneCurveFilter:(UIImage *)image;
+ (UIImage *)applySketchFilter:(UIImage *)image;
/**
 GPUImageGaussianBlurFilter
 GPUImageBoxBlurFilter
 GPUImageGaussianSelectiveBlurFilter
 GPUImageiOSBlurFilter
 GPUImageMotionBlurFilter
 GPUImageZoomBlurFilter
 */
//GPUImageLocalBinaryPatternFilter.h
+ (UIImage *)applyLocalBinaryPatternFilter:(UIImage *)image;


//more add
+ (UIImage *)customfilter:(NSString *)str image:(UIImage *)image;
+ (UIImage *)snapchatFilter:(UIImage *)image;

//工程路径路径，如果是正常项目需要进行下载存放进沙盒再进行读取
+ (UIImage *)qmfilter:(UIImage *)image index:(NSInteger)index;

@end
