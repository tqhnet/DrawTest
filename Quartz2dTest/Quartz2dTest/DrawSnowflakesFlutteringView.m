//
//  DrawSnowflakesFlutteringView.m
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "DrawSnowflakesFlutteringView.h"
@interface DrawSnowflakesFlutteringView()
{
    CGFloat _snowY;//雪花的y坐标
    UIImage *_snowImage;
}

@end
@implementation DrawSnowflakesFlutteringView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 创建定时器
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
        
        // 添加主运行循环
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)timeChange{
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //设置下雪的动画
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);

    NSString *str = @"❄️❄️";
    [str drawInRect:CGRectMake(0, 0, 50, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *image = newImage;
    _snowY += 1;
    
    [image drawAtPoint:CGPointMake(0, _snowY)];
    if (_snowY >= rect.size.height) {
        _snowY = 0;
    }
}

- (void)dealloc {
    NSLog(@"被销毁了");
}

@end
