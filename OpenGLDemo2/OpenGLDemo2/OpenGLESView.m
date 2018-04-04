//
//  OpenGLESView.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//
//系列教程链接：https://www.jianshu.com/c/30e2e76bc140

#import "OpenGLESView.h"
#import <OpenGLES/ES2/gl.h>
#import "GLUtil.h"

@interface OpenGLESView()
{
    GLuint _colorRenderBuffer;  //颜色渲染缓冲
    GLuint _frameBuffer;        //frame缓冲
    GLuint _program;            //着色器参数
}
@property (nonatomic,strong) CAEAGLLayer *eaglLayer;    //layer
@property (nonatomic,strong) EAGLContext *context;      //上下文


@end

@implementation OpenGLESView

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
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag.glsl" ofType:nil];
    _program = createGLProgramFromFile(vertFile.UTF8String, fragFile.UTF8String);
    
    glUseProgram(_program);
}



- (void)destoryRenderAndFrameBuffer {
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

#pragma mark - render

- (void)render {
    glClearColor(1.0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    //没有添加这一句是绘制不出来的
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    //绘制2d三角形
//    [self setupVertexData];
    
    //绘制2d圆形
    [self setupCircle];
    
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

#pragma mark - others

//绘制三角形
- (void)setupVertexData {
    // 需要加static关键字，否则数据传输存在问题
    
    //绘制一个三角形并设置颜色
    static GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    GLint posSlot = glGetAttribLocation(_program, "position");
    glVertexAttribPointer(posSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(posSlot);
    static GLfloat colors[] = {
        0.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f
    };
    GLint colorSlot = glGetAttribLocation(_program, "color");
    glVertexAttribPointer(colorSlot, 3, GL_FLOAT, GL_FALSE, 0, colors);
    glEnableVertexAttribArray(colorSlot);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

typedef struct {
    GLfloat x,y,z;
    GLfloat r,g,b;
} Vertex;

//绘制圆形
- (void)setupCircle {
    int vertCount = 100;//分割数
    Vertex *vertext = (Vertex *)malloc(sizeof(Vertex) *vertCount);
    memset(vertext, 0x00, sizeof(Vertex) * vertCount);
    float a = 0.8; // 水平方向的半径
    float b = a * self.frame.size.width / self.frame.size.height;//垂直方向
    float delta = 2.0 * M_PI/vertCount;  // 1/100的弧度
    
    //画出100点
    for (int i = 0; i < vertCount; i++) {
        
        GLfloat x = a * cos(delta * i);
        GLfloat y = b * sin(delta * i);
        GLfloat z = 0.0;
        
        //圆的每一点的坐标
        vertext[i] = (Vertex){x, y, z, x, y, x+y};
        
        printf("%f , %f\n", x, y);
    }
    
    glEnableVertexAttribArray(glGetAttribLocation(_program, "position"));
    glVertexAttribPointer(glGetAttribLocation(_program, "position"), 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), vertext);
    
    //x,y,x+y最大为1，所以可可直接作为颜色rgb
    glEnableVertexAttribArray(glGetAttribLocation(_program, "color"));
    glVertexAttribPointer(glGetAttribLocation(_program, "color"), 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), vertext+sizeof(GLfloat)*3);
    
    //绘制100个三角扇形合并起来
    //GL_LINE_LOOP:线圈
    glDrawArrays(GL_TRIANGLE_FAN, 0, vertCount);
    
}


@end
