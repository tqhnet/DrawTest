//
//  OpenGLESView_Base.h
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import "GLUtil.h"
/**基础OpenGL视图*/
@interface OpenGLESView_Base : UIView
{
    GLuint _program;            //着色器参数,子类千万不要重新初始化这个不然会不显示图像的
    EAGLContext *_context;
}
@property (nonatomic,strong) EAGLContext *context;      //上下文


- (NSDictionary *)getVertFileANDfragFileName;
//渲染绘制
- (void)drawContent;

@end
