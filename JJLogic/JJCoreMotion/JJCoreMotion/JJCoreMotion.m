//
//  JJCoreMotion.m
//  JJCoreMotion
//
//  Created by farbell-imac on 16/7/12.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCoreMotion.h"
#import <CoreMotion/CoreMotion.h>

@implementation JJCoreMotion{
    CMPedometer *pedometer;// 计步器
    CMMotionManager *motionmanger;
}

// 计步器
- (void)setupPedometer{
    if (![CMPedometer isStepCountingAvailable]) {
        NSLog(@"CMPedometer不可用");
        return;
    }
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        NSLog(@"%@",pedometerData.numberOfSteps);
    }];
}

- (void)setupAll{
    motionmanger = [[CMMotionManager alloc]init];
    //[self setupPedometer];
    [self setupGyro];
    [self setupMagnetometer];
    [self setupAccelerometer];
}

// Setup Magnetometer磁力计
- (void)setupMagnetometer{
    if (![motionmanger isMagnetometerAvailable]) {
        NSLog(@"磁力计不可用");
        return;
    }
    motionmanger.magnetometerUpdateInterval = 1.0;
    [motionmanger startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        CMMagneticField filed = magnetometerData.magneticField;
        NSLog(@"磁力计 x:%f,y:%f,z:%f",filed.x,filed.y,filed.z);
    }];
}

// Setup Gyro陀螺仪
- (void)setupGyro{
    if (![motionmanger isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
        return;
    }
    motionmanger.gyroUpdateInterval = 1.0;
    [motionmanger startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        CMRotationRate rate = gyroData.rotationRate;
        NSLog(@"陀螺仪 x:%f y:%f z:%f", rate.x, rate.y, rate.z);
    }];
}

// Setup Accelerometer加速计
-(void)setupAccelerometer{
    if (![motionmanger isAccelerometerAvailable]) {
        NSLog(@"加速计不可用");
        return;
    }
    //设置采取 时间间隔
    motionmanger.accelerometerUpdateInterval =0.1;
    [motionmanger startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"加速计x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    }];
    
}


@end
