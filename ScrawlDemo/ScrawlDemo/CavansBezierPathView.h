//
//  CavansBezierPathView.h
//  ScrawlDemo
//
//  Created by tqh on 2018/3/20.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPath.h"
@class HBDrawView;

/**画布视图，使用贝塞尔绘制，基本原理和第一种一样，这里就不详细介绍
 参考链接：https://github.com/WillieWu/HBDrawingBoardDemo
 */

@interface CavansBezierPathView : UIView

@property (nonatomic,strong) CustomPath *path;//路径
@property (nonatomic, strong) UIImageView *drawImage;
@property (nonatomic, strong) HBDrawView *drawView;

@end

@interface HBDrawView : UIView

- (void)setBrush:(CustomPath *)path;

@end
