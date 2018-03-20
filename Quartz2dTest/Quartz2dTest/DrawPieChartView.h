//
//  DrawPieChartView.h
//  Quartz2dTest
//
//  Created by tqh on 2018/3/19.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**绘制饼状图*/
@interface DrawPieChartView : UIView

@property(nonatomic,strong) NSArray *nums;
@property(assign,nonatomic) NSInteger total;

@end
