//
//  JJCLLocation.m
//  JJCLLocation
//
//  Created by farbell-imac on 16/7/30.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocation.h"

@implementation JJCLLocation

- (void)setupCLLocation{
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"请打开定位服务！");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self.locMgr requestAlwaysAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        [self.locMgr startUpdatingLocation];
    }
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLLocation * loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,loc.altitude,loc.course,loc.speed);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSLog(@"进入后台了！！！");
       
    }
    
}
#pragma mark 懒加载
-(CLLocationManager *)locMgr
{
    if (!_locMgr)
    {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
    }
    return _locMgr;
}

@end
