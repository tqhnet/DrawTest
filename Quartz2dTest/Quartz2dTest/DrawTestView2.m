//
//  DrawTestView2.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "DrawTestView2.h"

@implementation DrawTestView2

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [self drawImage:context];
//    [self drawImage2:context];
    [self drawImage3:context];
}

#pragma mark - 图形上下文改变

- (void)drawImage:(CGContextRef)context {
    
    //保存初始状态
    CGContextSaveGState(context);
    
    //平移
    CGContextTranslateCTM(context, 100, 0);
    
    //缩放
    CGContextScaleCTM(context, 0.8, 0.8);
    
    //旋转
    CGContextRotateCTM(context, M_PI_4/4);

    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    [image drawInRect:CGRectMake(0, 50, 240, 240)];
    
    //恢复
    CGContextRestoreGState(context);
}

/**使用core graphics绘制,Core Graphics中坐标系的y轴正方向是向上的,用旋转再和高度，y坐标处理算出正常显示*/
- (void)drawImage2:(CGContextRef)context {
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    //图像绘制
    CGSize size=[UIScreen mainScreen].bounds.size;
    CGContextSaveGState(context);
    CGFloat height=240,y=50;
    //上下文形变
    CGContextScaleCTM(context, 1.0, -1.0);//在y轴缩放-1相当于沿着x张旋转180
    CGContextTranslateCTM(context, 0, -(size.height-(size.height-2*y-height)));//向上平移
    //图像绘制
    CGRect rect= CGRectMake(10, y, 240, height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextRestoreGState(context);
}


#pragma mark - 利用位图上下文添加水印效果

- (void)drawImage3:(CGContextRef)context {
    UIImage *image = [self drawImageAtImageContext];
    [image drawInRect:CGRectMake(0, 50, 240, 240)];
}

- (UIImage *)drawImageAtImageContext {
    
    //获取一个位图图形上下文
    CGSize size = CGSizeMake(300, 180);
    UIGraphicsBeginImageContext(size);
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //添加水印
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 200, 178);
    CGContextAddLineToPoint(context, 270, 178);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    NSString *str = @"幻想无极";
    
    [str drawInRect:CGRectMake(200, 158, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 利用pdf图形上下文绘制内容到pdf文档

- (void)drawContentToPdfContext {
    
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingPathComponent:@"myPDF.pdf"];
    NSLog(@"%@",path);
    
    //启用pdf图形上下文
    /**
     path:保存路径
     bounds:pdf文档大小，如果设置为CGRectZero则使用默认值：612*792
     pageInfo:页面设置,为nil则不设置任何信息
     */
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, [NSDictionary dictionaryWithObjectsAndKeys:@"tqh",kCGPDFContextAuthor, nil]);
    
    //创建pdf画布
    UIGraphicsBeginPDFPage();
    
    NSString *title=@"Welcome to Apple Support";
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
    NSTextAlignment align=NSTextAlignmentCenter;
    style.alignment=align;
    [title drawInRect:CGRectMake(26, 20, 300, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:style}];
    NSString *content=@"Learn about Apple products, view online manuals, get the latest downloads, and more. Connect with other Apple users, or get service, support, and professional advice from Apple.";
    NSMutableParagraphStyle *style2=[[NSMutableParagraphStyle alloc]init];
    style2.alignment=NSTextAlignmentLeft;
    //    style2.firstLineHeadIndent=20;
    [content drawInRect:CGRectMake(26, 56, 300, 255) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:style2}];
    
    
    
    UIImage *image=[UIImage imageNamed:@"test.jpg"];
    [image drawInRect:CGRectMake(316, 20, 290, 305)];
    
    UIImage *image2=[UIImage imageNamed:@"test.jpg"];
    [image2 drawInRect:CGRectMake(6, 320, 600, 281)];
    
    //创建新的一页继续绘制其他内容
    UIGraphicsBeginPDFPage();
    UIImage *image3=[UIImage imageNamed:@"test.jpg"];
    [image3 drawInRect:CGRectMake(6, 20, 600, 629)];
    
    //结束pdf上下文
    UIGraphicsEndPDFContext();
}

@end
