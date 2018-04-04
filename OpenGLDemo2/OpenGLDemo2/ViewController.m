//
//  ViewController.m
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/3.
//  Copyright © 2018年 tqh. All rights reserved.
//

// opengl学习地址:https://www.jianshu.com/c/30e2e76bc140


#import "ViewController.h"
#import "OpenGLESView.h"
#import "OpenGLESView_VAO.h"
#import "OpenGLESView_Image.h"
#import "OpenGLESView_Overlap.h"
#import "OpenGLESView_Instance.h"
//#import "OpenGLESManager.h"
#import "OpenGLESView_FrameBuffer.h"
#import "OpenGLESView_Hybrid.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view = [[OpenGLESView alloc]initWithFrame:self.view.bounds];
    self.view = [[OpenGLESView_Overlap alloc]initWithFrame:self.view.bounds];
    
}

@end
