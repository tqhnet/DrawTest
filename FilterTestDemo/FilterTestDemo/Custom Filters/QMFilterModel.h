//
//  QMFilterModel.h
//  EnjoyCamera
//
//  Created by qinmin on 2017/8/21.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import <Foundation/Foundation.h>
//  基于EnjoyCamera，可在github搜索
/**通过路径创建数据模型*/

@interface QMFilterModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *enName;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *fragmentShader;
@property (nonatomic, assign) float currentAlphaValue;
@property (nonatomic, strong) NSArray<NSString *> *textureImages;

+ (QMFilterModel *)buildFilterModelWithFilterPath:(NSString *)filter;
+ (NSArray<QMFilterModel *> *)buildFilterModelsWithPath:(NSString *)folder;

@end
