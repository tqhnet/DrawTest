//
//  DrawHistogramView.h
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**绘制柱状图*/
@interface DrawHistogramView : UIView

@property(nonatomic,strong) NSArray *nums;
@property(assign,nonatomic) NSInteger total;

@end
