//
//  OpenGLESView_Camera.h
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/4.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLRender.h"

@interface OpenGLESView_Camera : UIView

@property (nonatomic, strong) GLRender *render;
- (void)setTexture:(GLTexture *)texture;
- (void)setNeedDraw;

@end

