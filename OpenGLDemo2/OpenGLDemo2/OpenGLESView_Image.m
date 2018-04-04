//
//  OpenGLESView_Image.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_Image.h"
#import <OpenGLES/ES2/gl.h>
#import "GLUtil.h"
#include "JpegUtil.h"

@interface OpenGLESView_Image()
{
    GLuint _colorRenderBuffer;  //颜色渲染缓冲
    GLuint _frameBuffer;        //frame缓冲
    GLuint _program;            //着色器参数
    GLuint          _vbo;
    GLuint          _texture;
    int             _vertCount;
}
@property (nonatomic,strong) CAEAGLLayer *eaglLayer;    //layer
@property (nonatomic,strong) EAGLContext *context;      //上下文

@end

@implementation OpenGLESView_Image


+ (Class)layerClass {
    //支持opengl绘制
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setUpContext];
        [self setupGLProgram];
        [self setupVBO];
        [self setupTexure];
    }
    return self;
}

- (void)layoutSubviews {
    
    //每次重新设置上下文？
    [EAGLContext setCurrentContext:_context];
    [self destoryRenderAndFrameBuffer];
    [self setupFrameAndRenderBuffer];
    [self render];
}

#pragma mark - setup

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties =  [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setUpContext {
    //使用opengl2.0
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    //将当前上下文设置为自己的上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupFrameAndRenderBuffer {
    /**下面的函数方法很容易写错，如果黑屏，很大一部分原因就是这里*/
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    //为color renderbuffer分配颜色储存空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    //设置为当前的framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    // 将_colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
}

- (void)setupGLProgram {
    //原图
//    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert_image.glsl" ofType:nil];
//    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag_image.glsl" ofType:nil];
    
    //膨胀
//    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"expand_vert.glsl" ofType:nil];
//    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"expand_frag.glsl" ofType:nil];
    
    //收缩
//    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"corrode_vert.glsl" ofType:nil];
//    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"corrode_frag.glsl" ofType:nil];
    
    //模糊
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"blur_vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"blur_frag.glsl" ofType:nil];
    
    _program = createGLProgramFromFile(vertFile.UTF8String, fragFile.UTF8String);
    
    glUseProgram(_program);
}

- (void)destoryRenderAndFrameBuffer {
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

- (void)setupVBO
{
    _vertCount = 6;
    
    //    GLfloat vertices[] = {
    //        0.5f,  0.5f, 0.0f, 1.0f, 1.0f,   // 右上
    //        0.5f, -0.5f, 0.0f, 1.0f, 0.0f,   // 右下
    //        -0.5f, -0.5f, 0.0f, 0.0f, 0.0f,  // 左下
    //        -0.5f,  0.5f, 0.0f, 0.0f, 1.0f   // 左上
    //    };
    
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
    
    //下面方法也能实现
//   [self setupTexture:@"wood.jpg"];
}

#pragma mark - render

- (void)render {
    glClearColor(1.0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    //没有添加这一句是绘制不出来的
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    //激活纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(_program, "image"), 0);
    glDrawArrays(GL_TRIANGLES, 0, _vertCount);
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
//    NSString *str;
//    [str stringByAppendingString:@""];
}

#pragma mark - others

- (GLuint)setupTexture:(NSString *)fileName {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    free(spriteData);
    return 0;
}

@end
