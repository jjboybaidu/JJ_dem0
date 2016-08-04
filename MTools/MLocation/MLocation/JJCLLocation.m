//
//  JJCLLocationBackGround.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocation.h"
#import "JJCLLocationGeocode.h"
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocation()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locationManager;

@end

@implementation JJCLLocation{
     NSDate *lastTimestamp;
    JJCLLocationGeocode *geocode;
}

// WAY 1
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        JJCLLocation *instance = sharedInstance;
        instance.locationManager = [CLLocationManager new];
        instance.locationManager.delegate = instance;
        instance.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // you can use kCLLocationAccuracyHundredMeters to get better battery life
        instance.locationManager.pausesLocationUpdatesAutomatically = NO; // this is important
        instance.locationManager.activityType = CLActivityTypeAutomotiveNavigation;// 定义位置更新数据用来作为步行导航
        // instance.locationManager.distanceFilter = 500;// 相隔500米更新一次
    });
    
    return sharedInstance;
}

- (void)startUpdatingLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are disabled in settings.");
    }
    else
    {
        // for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        // for iOS 9
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        
        // Request a location update
        [self.locationManager requestLocation];
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    geocode = [JJCLLocationGeocode sharedInstance];
    
    // reverse Geocode反地理编码 坐标-->地名
    [geocode reverseGeocode:locations];
    
    if (geocode.name != nil) {
        self.name = geocode.name;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"error %@",error);
}

@end
