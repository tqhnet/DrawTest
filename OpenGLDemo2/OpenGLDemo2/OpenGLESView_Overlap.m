//
//  OpenGLESView_Overlap.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/4.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_Overlap.h"
#import "JpegUtil.h"

@interface OpenGLESView_Overlap()
{
    GLuint          _vbo;
    GLuint          _texture1;
    GLuint          _texture2;
    int             _vertCount;
}
@end

@implementation OpenGLESView_Overlap

- (void)dealloc
{
    glDeleteBuffers(1, &_vbo);
    glDeleteTextures(1, &_texture1);
    glDeleteTextures(1, &_texture2);
    glDeleteProgram(_program);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupVBO];
        [self setupTexure1];
        [self setupTexure2];
    }
    return self;
}

- (void)setupVBO
{
    _vertCount = 6;
    
    //绘制两个三角形构成矩形
    GLfloat vertices[] = {
        0.8f,  0.6f, 0.0f, 1.0f, 0.0f,   // 右上
        0.8f, -0.6f, 0.0f, 1.0f, 1.0f,   // 右下
        -0.8f, -0.6f, 0.0f, 0.0f, 1.0f,  // 左下
        
        -0.8f, -0.6f, 0.0f, 0.0f, 1.0f,  // 左下
        -0.8f,  0.6f, 0.0f, 0.0f, 0.0f,  // 左上
        0.8f,  0.6f, 0.0f, 1.0f, 0.0f,   // 右上
    };
    
    // 创建VBO
    _vbo = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "position"));
    glVertexAttribPointer(glGetAttribLocation(_program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(_program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
}

- (void)setupTexure1
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"me" ofType:@"jpg"];
    
    unsigned char *data;
    int size;
    int width;
    int height;
    
    // 加载纹理
    if (read_jpeg_file(path.UTF8String, &data, &size, &width, &height) < 0) {
        printf("%s\n", "decode fail");
    }
    
    // 创建纹理
    _texture1 = createTexture2D(GL_RGB, width, height, data);
    
    if (data) {
        free(data);
        data = NULL;
    }
}

- (void)setupTexure2
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"noise" ofType:@"jpg"];
    
    unsigned char *data;
    int size;
    int width;
    int height;
    
    // 加载纹理
    if (read_jpeg_file(path.UTF8String, &data, &size, &width, &height) < 0) {
        printf("%s\n", "decode fail");
    }
    
    // 创建纹理
    _texture2 = createTexture2D(GL_RGB, width, height, data);
    
    if (data) {
        free(data);
        data = NULL;
    }
}

#pragma mark - super

- (void)drawContent {
    // 激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture1);
    glUniform1i(glGetUniformLocation(_program, "image1"), 0);
    
    // 激活纹理
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _texture2);
    glUniform1i(glGetUniformLocation(_program, "image2"), 1);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
}

- (NSDictionary *)getVertFileANDfragFileName {
    return @{@"vert":@"overlap_vert",@"frag":[self getFragFileName]};
}

- (NSString *)getFragFileName {
    return @"overlap_frag";
}

@end
