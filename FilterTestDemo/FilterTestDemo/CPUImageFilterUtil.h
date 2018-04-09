//
//  CPUImageFilterUtil.h
//  FilterTestDemo
//
//  Created by tqh on 2018/3/26.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//LOMO
static const float colormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
static const float colormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };
//复古
static const float colormatrix_huajiu[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
static const float colormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐化
static const float colormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
static const float colormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//酒红
static const float colormatrix_jiuhong[] = {
    1.2f,0.0f, 0.0f, 0.0f,0.0f,
    0.0f,0.9f, 0.0f, 0.0f,0.0f,
    0.0f,0.0f, 0.8f, 0.0f,0.0f,
    0, 0, 0, 1.0f, 0 };

//清宁
static const float colormatrix_qingning[] = {
    0.9f, 0, 0, 0, 0,
    0, 1.1f,0, 0, 0,
    0, 0, 0.9f, 0, 0,
    0, 0, 0, 1.0f, 0 };

//浪漫
static const float colormatrix_langman[] = {
    0.9f, 0, 0, 0, 63.0f,
    0, 0.9f,0, 0, 63.0f,
    0, 0, 0.9f, 0, 63.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
static const float colormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//蓝调
static const float colormatrix_landiao[] = {
    2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
    -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
    -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//梦幻
static const float colormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
static const float colormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

static const float colormatrixs[][20]={
    {
        0.8f,  1.6f, 0.2f, 0, -163.9f,
        0.8f,  1.6f, 0.2f, 0, -163.9f,
        0.8f,  1.6f, 0.2f, 0, -163.9f,
        0,  0, 0, 1.0f, 0
    },
    {
        0.2f,0.5f, 0.1f, 0, 40.8f,
        0.2f, 0.5f, 0.1f, 0, 40.8f,
        0.2f,0.5f, 0.1f, 0, 40.8f,
        0, 0, 0, 1, 0
    },
    {
        1.9f,-0.3f, -0.2f, 0,-87.0f,
        -0.2f, 1.7f, -0.1f, 0, -87.0f,
        -0.1f,-0.6f, 2.0f, 0, -87.0f,
        0, 0, 0, 1.0f, 0
    },
    {
        4.8f,-1.0f, -0.1f, 0,-388.4f,
        -0.5f,4.4f, -0.1f, 0,-388.4f,
        -0.5f,-1.0f, 5.2f, 0,-388.4f,
        0, 0, 0, 1.0f, 0
    },
    {
        0.6f,0.3f, 0.1f, 0,73.3f,
        0.2f,0.7f, 0.1f, 0,73.3f,
        0.2f,0.3f, 0.4f, 0,73.3f,
        0, 0, 0, 1.0f, 0
    },
    {
        1.2f,0.0f, 0.0f, 0.0f,0.0f,
        0.0f,0.9f, 0.0f, 0.0f,0.0f,
        0.0f,0.0f, 0.8f, 0.0f,0.0f,
        0, 0, 0, 1.0f, 0
    },
    {
        0.9f, 0, 0, 0, 0,
        0, 1.1f,0, 0, 0,
        0, 0, 0.9f, 0, 0,
        0, 0, 0, 1.0f, 0
    },
    {
        0.9f, 0, 0, 0, 63.0f,
        0, 0.9f,0, 0, 63.0f,
        0, 0, 0.9f, 0, 63.0f,
        0, 0, 0, 1.0f, 0
    },
    {
        0.9f, 0, 0,  0, 64.9f,
        0, 0.9f,0,  0, 64.9f,
        0, 0, 0.9f,  0, 64.9f,
        0, 0, 0, 1.0f, 0
    },
    {
        2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
        -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
        -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
        0.0f, 0.0f, 0.0f, 1.0f, 0.0f
    },
    {
        0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
        0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
        0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
        0.0f, 0.0f, 0.0f, 1.0f, 0.0f
    },
    {
        1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
        0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
        0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
        0.0f, 0.0f, 0.0f, 1.0f, 0.0f
    }
};

/**滤镜工具库，基于CoreGraphics*/
@interface CPUImageFilterUtil : NSObject

+ (UIImage *)imageWithImage:(UIImage *)inImage withColorMatrix:(const float*)f;


@end
