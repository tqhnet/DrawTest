//
//  OpenGLESView_Hybrid.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/4.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_Hybrid.h"
#import <OpenGLES/ES2/gl.h>
#import "GLUtil.h"
#include "JpegUtil.h"
#include "PngUtil.h"

@interface OpenGLESView_Hybrid()
{
    GLuint          _vbo;
    GLuint          _texture;
    GLuint          _texture1;
    int             _vertCount;
}
@end

@implementation OpenGLESView_Hybrid

- (void)dealloc
{
    glDeleteBuffers(1, &_vbo);
    glDeleteTextures(1, &_texture);
    glDeleteProgram(_program);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self setupVBO];
        [self setupTexure];
        [self setupTexure1];
    }
    return self;
}

- (void)setupVBO
{
    _vertCount = 6;
    
    GLfloat vertices[] = {
        0.5f,  0.5f, 0.0f, 1.0f, 0.0f,   // 右上
        0.5f, -0.5f, 0.0f, 1.0f, 1.0f,   // 右下
        -0.5f, -0.5f, 0.0f, 0.0f, 1.0f,  // 左下
        -0.5f, -0.5f, 0.0f, 0.0f, 1.0f,  // 左下
        -0.5f,  0.5f, 0.0f, 0.0f, 0.0f,  // 左上
        0.5f,  0.5f, 0.0f, 1.0f, 0.0f,   // 右上
    };
    
    // 创建VBO
    _vbo = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(vertices), vertices);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "position"));
    glVertexAttribPointer(glGetAttribLocation(_program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(_program, "texcoord"), 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL+sizeof(GL_FLOAT)*3);
}

- (void)setupTexure
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"png"];
 
    CGImageRef spriteImage = [UIImage imageNamed:path].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", path);
        exit(1);
    }
    
    // 2 读取图片的大小
    long width = CGImageGetWidth(spriteImage);
    long height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    _texture = createTexture2D(GL_RGBA, (int)width,(int)height, spriteData);
    
    free(spriteData);
    
}

- (void)setupTexure1
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"wood" ofType:@"png"];
    
    CGImageRef spriteImage = [UIImage imageNamed:path].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", path);
        exit(1);
    }
    
    // 2 读取图片的大小
    long width = CGImageGetWidth(spriteImage);
    long height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    _texture1 = createTexture2D(GL_RGBA, (int)width,(int)height, spriteData);
    
    free(spriteData);
    
}

#pragma mark - others

- (void)drawContent {
//    [self draw1];
    [self draw2];
//    [self draw3];
}

- (void)draw1 {
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // 激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(_program, "image"), 0);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
}

- (void)draw2 {
    // 第一个纹理关闭混合
    glDisable(GL_BLEND);
    
    // 激活纹理
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _texture1);
    glUniform1i(glGetUniformLocation(_program, "image"), 1);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
    
    // 渲染的时候开启混合
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE);
    
    // 激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(_program, "image"), 0);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
}

- (void)draw3 {
    

    // 激活纹理
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _texture1);
    glUniform1i(glGetUniformLocation(_program, "image"), 1);
    
    // 激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(_program, "image1"), 0);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
    
}

- (NSDictionary *)getVertFileANDfragFileName {
    return @{@"vert":@"overlap_vert",@"frag":[self getFragFileName]};
}

- (NSString *)getFragFileName {
    return @"hybrid_frag1";
}
//- (NSString *)getFragFileName {
//    return @"hybrid_frag2";
//}


@end
