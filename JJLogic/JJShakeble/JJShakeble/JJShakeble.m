//
//  JJShakeble.m
//  JJShakeble
//
//  Created by farbell-imac on 16/7/12.
//  Copyright © 2016年 farbell. All rights reserved.
//  亮屏摇一摇

#import "JJShakeble.h"
#import "JJCentralble.h"
#import <CoreMotion/CoreMotion.h>
#import <notify.h>

@interface JJShakeble()
@property(nonatomic,strong) CMMotionManager *motionManager;

@end

@implementation JJShakeble{
    BOOL isBright;
}

- (void)setupMotionManager{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.05;//加速仪更新频率，以秒为单位
    
    isBright = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueStart) name:@"centralble" object:nil];
    
    // 开启加速计
    [self startAccelerometer];
    
    // 监听屏幕亮屏灭屏
    [self registerAppforDetectBrightState];
}

- (void)continueStart{
    if (isBright) {
        [self startAccelerometer];
    }
}

-(void)registerAppforDetectBrightState {
    int notify_token;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&notify_token,dispatch_get_main_queue(), ^(int token) {
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        if(state == 0) {
            NSLog(@"亮屏");
            [self startAccelerometer];
            isBright = YES;
        } else {
            NSLog(@"灭屏");
            [self.motionManager stopAccelerometerUpdates];
            //TODO:移除BLE对象
            isBright = NO;
        }
        
    });
}

- (void)startAccelerometer{
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        [self outputAccelertionData:accelerometerData.acceleration];
        
        if (error) {
            NSLog(@"motion error:%@",error);
        }
    }];
}

// CMAcceleration为加速度
// acceleration of gravity]重力加速度( g的名词复数 )
// accelerameter is 综合3个方向的加速度;当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
// sqrt是平方根，sqrt(25)就是5，sqrt(36)就是6
// pow()用来计算以x 为底的y 次方值
// 2.3f的值是手机左右晃动加速度大于2.3的平方
// 重力在SI单位制中的计量单位是米/秒^2
- (void)outputAccelertionData:(CMAcceleration)acceleration{
    double accelerameter =sqrt( pow( acceleration.x , 2 ) + pow( acceleration.y , 2 ) + pow( acceleration.z , 2) );
    if (accelerameter>2.3f) {
        [self.motionManager stopAccelerometerUpdates];//立即停止更新加速仪（很重要！）
        dispatch_async(dispatch_get_main_queue(), ^{
            //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
            JJCentralble *centralble = [[JJCentralble alloc]init];
            [centralble initWithCentral];
        });
    }
}

@end
