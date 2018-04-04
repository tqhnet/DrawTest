//
//  OpenGLESView_Instance.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/4.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_Instance.h"
#import "JpegUtil.h"
#import <OpenGLES/ES3/gl.h>

@interface OpenGLESView_Instance()
{
    GLuint          _vbo;
    GLuint          _offsetVBO;
    GLuint          _texture;
    int             _vertCount;
}
@end

@implementation OpenGLESView_Instance

- (void)dealloc
{
    glDeleteBuffers(1, &_vbo);
    glDeleteTextures(1, &_texture);
    glDeleteProgram(_program);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupOffset];
        [self setupVBO];
        [self setupTexure];
    }
    return self;
}

- (void)setupOffset {
    GLfloat vertices[] = {
        0.7f, -0.7f, 0.0f,
        0.1f, -0.1f, 0.0f,
        1.3f, -1.3f, 0.0f,
    };
    
    // 创建VBO
    _offsetVBO = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "offset"));
    glVertexAttribPointer(glGetAttribLocation(_program, "offset"), 3, GL_FLOAT, GL_FALSE, 0, NULL);
}

- (void)setupVBO {
    _vertCount = 6;
    
    //设置顶点坐标
    GLfloat vertices[] = {
        -0.5f,  1.0f, 0.0f, 1.0f, 0.0f,   // 右上
        -0.5f,  0.5f, 0.0f, 1.0f, 1.0f,   // 右下
        -1.0f,  0.5f, 0.0f, 0.0f, 1.0f,  // 左下
        
        -1.0f,  0.5f, 0.0f, 0.0f, 1.0f,  // 左下
        -1.0f,  1.0f, 0.0f, 0.0f, 0.0f,  // 左上
        -0.5f,  1.0f, 0.0f, 1.0f, 0.0f,   // 右上
    };
    
    // 创建VBO
    _vbo = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "position"));
    glVertexAttribPointer(glGetAttribLocation(_program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(_program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
}

- (void)setupTexure {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wood" ofType:@"jpg"];
    
    unsigned char *data;
    int size;
    int width;
    int height;
    
    // 加载纹理
    if (read_jpeg_file(path.UTF8String, &data, &size, &width, &height) < 0) {
        printf("%s\n", "decode fail");
    }
    
    // 创建纹理
    _texture = createTexture2D(GL_RGB, width, height, data);
    
    if (data) {
        free(data);
        data = NULL;
    }
}

- (void)drawContent {
    // 激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(_program, "image"), 0);
    
    // 每次绘制之后，对offset进行1个偏移
    glVertexAttribDivisor(glGetAttribLocation(_program, "offset"), 1);
    glDrawArraysInstanced(GL_TRIANGLES, 0, _vertCount, 3);
}

- (NSDictionary *)getVertFileANDfragFileName {
    return @{@"vert":@"Instance_vert",@"frag":[self getFragFileName]};
}

- (NSString *)getFragFileName {
    return @"Instance_frag";
}
@end
