//
//  OpenGLESView_Base.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "OpenGLESView_Base.h"


@interface OpenGLESView_Base()
{
    GLuint _colorRenderBuffer;  //颜色渲染缓冲
    GLuint _frameBuffer;        //frame缓冲
    
}
@property (nonatomic,strong) CAEAGLLayer *eaglLayer;    //layer

@end

@implementation OpenGLESView_Base


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
    
    //创建一个帧缓存对象
    glGenRenderbuffers(1, &_colorRenderBuffer);
    
    //绑定帧缓存
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
    
    //如果图像显示不出来一般都是这里出错了
    NSDictionary *dic = [self getVertFileANDfragFileName];
    NSAssert(dic, @"需要重新获取vert和frag路径");
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:dic[@"vert"] ofType:@"glsl"];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:dic[@"frag"] ofType:@"glsl"];
    
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
    
    [self drawContent];
    
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)drawContent {
    
}

- (NSDictionary *)getVertFileANDfragFileName {
    return @{@"vert":@"vert",@"frag":@"frag"};
}

@end
