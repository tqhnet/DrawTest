//
//  CPUImageFilterUtil.m
//  FilterTestDemo
//
//  Created by tqh on 2018/3/26.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "CPUImageFilterUtil.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation CPUImageFilterUtil

// 返回一个使用RGBA通道的位图上下文
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    
    //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    void *bitmapData;
    
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    //获取横向的像素点的个数
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage); //纵向
    
    //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    //计算整张图占用的字节数
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    //创建依赖于设备的RGB通道
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc(bitmapByteCount);
    
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
//将输入图片绘制到创建的上下文中
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    
    CGRect rect = {{0,0},{size.width, size.height}};
    
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

//进行矩阵颜色的改变
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    *blue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    *alpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    
    if (*red > 255)
    {
        *red = 255;
    }
    if(*red < 0)
    {
        *red = 0;
    }
    if (*green > 255)
    {
        *green = 255;
    }
    if (*green < 0)
    {
        *green = 0;
    }
    if (*blue > 255)
    {
        *blue = 255;
    }
    if (*blue < 0)
    {
        *blue = 0;
    }
    if (*alpha > 255)
    {
        *alpha = 255;
    }
    if (*alpha < 0)
    {
        *alpha = 0;
    }
}

//通过颜色矩阵改变输入的图像
+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
    //取得绘制过的上下文
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    GLuint w = (GLuint)CGImageGetWidth(inImageRef);
    GLuint h = (GLuint)CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    
    //双层循环按照长宽的像素个数迭代每个像素点
    //迭代像素点，进行像素点的改变
    for(GLuint y = 0;y< h;y++)
    {
        pixOff = wOff;
        
        for (GLuint x = 0; x<w; x++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha = (unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, f);
            
//            NSLog(@"red = %d green = %d blue = %d aplha = %d",red,green,blue,alpha);
            
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            //将数组的索引指向下四个元素
            pixOff += 4;
        }
        
        wOff += w * 4;
    }
    
    NSInteger dataLength = w * h * 4;
    
    //下面的代码创建要输出的图像的相关参数.
    //其中(CGDataProviderReleaseDataCallback)&freeData要做的内存释放非常关键, 采用回调函数的方式进行释放(因data不能在此时释放, 否则就得不到处理后的图片).
    //推断:iOS在绘制UIImage的时候使用的内存信息只是作了一个简单的引用指向，所以我们立即释放data的话就会造成数据错误。
    //如果仔细看CGDataProviderCreateWithData方法的注释，正确的做法应该是实现自己的释放方法，然后将该方法作为CGDataProviderCreateWithData的最后一个参数进行传入，那么CGDataProviderRef释放的时候就会对该CGDataProviderReleaseDataCallback进行回调，在里面我们可以安全释放我们的图像数据。
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, (CGDataProviderReleaseDataCallback)&freeData);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    //创建要输出的图像
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    //生成新图像
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return myImage;
}

void freeData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}


@end
