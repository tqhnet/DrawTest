//
//  OpenGLESView_VAO.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_VAO.h"
#import "GLUtil_ES3.h"
//#import <OpenGLES/ES3/gl.h>

typedef struct {
    GLfloat x,y,z;
    GLfloat r,g,b;
} Vertex;

@interface OpenGLESView_VAO()
{
    CAEAGLLayer     *_eaglLayer;
    EAGLContext     *_context;
    GLuint          _colorRenderBuffer;
    GLuint          _frameBuffer;
    
    GLuint          _program;
    int             _vertCount;
    
    Vertex          *_vertext;
    GLuint          _vao;
}
@end

@implementation OpenGLESView_VAO


- (void)dealloc
{
    if (_vertext) {
        free(_vertext);
    }
}
+ (Class)layerClass {
    //配置opengl绘图
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置画布属性
        [self setupLayer];
        //创建上下文 opengl3.0
        [self setupContext];
        //配置shader
        [self setupGLProgram];
        //创建顶点数据
        [self setupVertexData];
        //设置顶点数据缓冲
        [self setupVAO];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    //获取当前上下文
    [EAGLContext setCurrentContext:_context];
    //清除渲染和frame缓冲
    [self destoryRenderAndFrameBuffer];
    //加载渲染和frame缓冲
    [self setupFrameAndRenderBuffer];
    //开始渲染
    [self render];
}

#pragma mark - setup

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext
{
    // 设置OpenGLES的版本为3.0
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 3.0 context");
        exit(1);
    }
    
    // 将当前上下文设置为我们创建的上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupGLProgram
{
    //注意，着重注意，shader也要使用es3不然的话绘制不出来，找了很久才发现...
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert_es3.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag_es3.glsl" ofType:nil];
    _program = createGLProgramFromFile(vertFile.UTF8String, fragFile.UTF8String);
    
    glUseProgram(_program);
}

- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

- (void)setupFrameAndRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

#pragma mark - Render
- (void)render
{
    glClearColor(1.0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glLineWidth(2.0);
    
    //需要这一句
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // VAO
    glBindVertexArray(_vao);
    
    glDrawArrays(GL_LINE_STRIP, 0, _vertCount);
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - others

- (void)setupVertexData
{
    CGPoint p1 = CGPointMake(-0.8, 0);
    CGPoint p2 = CGPointMake(0.8, 0.2);
    CGPoint control = CGPointMake(0, -0.9);
    CGFloat deltaT = 0.01;
    
    _vertCount = 1.0/deltaT;
    _vertext = (Vertex *)malloc(sizeof(Vertex) * _vertCount);
    
    // t的范围[0,1]
    for (int i = 0; i < _vertCount; i++) {
        float t = i * deltaT;
        
        // 二次方计算公式
        float cx = (1-t)*(1-t)*p1.x + 2*t*(1-t)*control.x + t*t*p2.x;
        float cy = (1-t)*(1-t)*p1.y + 2*t*(1-t)*control.y + t*t*p2.y;
        _vertext[i] = (Vertex){cx, cy, 0.0, 1.0, 0.0, 0.0};
        
        printf("%f, %f\n",cx, cy);
    }
}

- (void)setupVAO {
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    // VBO
    GLuint vbo = createVBO(GL_ARRAY_BUFFER, GL_STATIC_DRAW, sizeof(Vertex) * (_vertCount + 1), _vertext);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL);
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), NULL+sizeof(GLfloat)*3);
    
    glBindVertexArray(0);
}

@end
