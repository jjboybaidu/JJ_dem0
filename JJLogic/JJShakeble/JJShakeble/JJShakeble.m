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
    BOOL isSending;
    JJCentralble *centralble;
}

- (void)setupMotionManager{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.05;//加速仪更新频率，以秒为单位
    isBright = YES;
    isSending = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reStart) name:@"centralble" object:nil];
    // 开启加速计
    [self startAccelerometerWithHandle];
    // 监听屏幕亮屏灭屏
    [self registerAppforDetectBrightState];
}

- (void)reStart{
    isSending = NO;
}


- (void)startAccelerometerWithHandle{
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        double accelerameter =sqrt( pow( accelerometerData.acceleration.x , 2 ) + pow( accelerometerData.acceleration.y , 2 ) + pow( accelerometerData.acceleration.z , 2) );
        if (!isSending && isBright && accelerameter > 2.3f) {
            isSending = YES;
            centralble = [[JJCentralble alloc]init];
            [centralble setupCentral];
        }
        
        if (error) {
            NSLog(@"motion error:%@",error);
        }
    }];
    
}

-(void)registerAppforDetectBrightState {
    int notify_token;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&notify_token,dispatch_get_main_queue(), ^(int token) {
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        if(state == 0) {
            NSLog(@"亮屏");
            isBright = YES;
        } else {
            NSLog(@"灭屏");
            isBright = NO;
        }
        
    });
}


@end
