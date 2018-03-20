//
//  DrawTestView2.h
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**包含图像旋转，平移，缩放,pdf绘制等*/
@interface DrawTestView2 : UIView
- (UIImage *)drawImageAtImageContext;
- (void)drawContentToPdfContext;

/**
1.Core Graphics是基于C语言的一套框架，开发时无法像使用Obj-C一样调用；

2.在Quartz 2D中凡是使用带有“Create”或者“Copy”关键字方法创建的对象，在使用后一定要使用对应的方法释放（由于这个框架基于C语言编写无法自动释放内存）；

3.Quartz 2D是跨平台的，因此其中的方法中不能使用UIKit中的对象（UIKit只有iOS可用），例如用到的颜色只能用CGColorRef而不能用UIColor，但是UIKit中提供了对应的转换方法；

4.在C语言中枚举一般以“k”开头，由于Quartz 2D基于C语言开发，所以它也不例外（参数中很多枚举都是k开头的）；

5.由于Quartz 2D是Core Graphics的一部分，所以API多数以CG开头；

6.在使用Quartz 2D绘图API中所有以“Ref”结尾对象，在声明时都不必声明为指针类型；

7.在使用Quartz 2D绘图API时，凡是“UI”开头的相关绘图函数，都是UIKit对Core Graphics的封装（主要为了简化绘图操作）；
*/

@end
