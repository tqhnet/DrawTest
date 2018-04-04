//
//  OpenGLESManager.h
//  OpenGLDemo2
//
//  Created by tqh on 2018/4/4.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLESView_Camera.h"
#import "libyuv.h"

@interface OpenGLESManager : NSObject

@property (nonatomic,strong) OpenGLESView_Camera *view;

- (void)setupSession;
- (void)startCamera;

@end
