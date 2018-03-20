//
//  DrawHistogramView.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "DrawHistogramView.h"

@implementation DrawHistogramView

-(NSArray *)nums{
    if (!_nums) {
        _nums = @[@23,@34,@93,@2,@55,@46];
    }
    return _nums;
}

//只有在drawRect方法中才能拿到图形上下文，才可以画图
- (void)drawRect:(CGRect)rect {
    
    //1.获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.绘制图像
    CGFloat margin = 30;
    CGFloat width = (rect.size.width - (self.nums.count + 1)*margin)/self.nums.count;
    for (int i = 0; i < self.nums.count; i++) {
        
        CGFloat x = margin + (width + margin)*i;
        CGFloat num = [self.nums[i] floatValue]/100;
        CGFloat y = rect.size.height * (1-num);
        CGFloat height = rect.size.height*num;
        
        CGRect rectA =  CGRectMake(x, y, width, height);
        CGContextAddRect(ctx,rectA);
//        [[self randomColor] set];
        [[UIColor redColor]set];
        CGContextFillPath(ctx);
    }
}


@end
