//
//  JJCLLocationBackGround.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationBackGround.h"
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocationBackGround()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locationManager;

@end

@implementation JJCLLocationBackGround{
     NSDate *lastTimestamp;
}

// WAY 1
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        JJCLLocationBackGround *instance = sharedInstance;
        instance.locationManager = [CLLocationManager new];
        instance.locationManager.delegate = instance;
        instance.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // you can use kCLLocationAccuracyHundredMeters to get better battery life
        instance.locationManager.pausesLocationUpdatesAutomatically = NO; // this is important
        instance.locationManager.activityType = CLActivityTypeAutomotiveNavigation;// 定义位置更新数据用来作为步行导航
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
        
        [self.locationManager startUpdatingLocation];
        // [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = locations.lastObject;
    NSLog(@"Current location: %@ %@", @(mostRecentLocation.coordinate.latitude), @(mostRecentLocation.coordinate.longitude));
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = lastTimestamp ? [now timeIntervalSinceDate:lastTimestamp] : 0;
    
    if (!lastTimestamp || interval >= 10)
    {
        lastTimestamp = now;
        NSLog(@"Sending current location to web service.");
    }
}



// WAY 2
/*

-(void)startBackgroundLocationUpdates {
    // Create a location manager object
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the delegate
    self.locationManager.delegate = self;
    
    // Request location authorization
    [self.locationManager requestWhenInUseAuthorization];
    
    // Set an accuracy level. The higher, the better for energy.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    // Enable automatic pausing
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    
    // Specify the type of activity your app is currently performing
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Enable background location updates
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    // Start location updates
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    // Process the received location update
    
    // Stop location updates
    [self.locationManager stopUpdatingLocation];
    
    // Disable background location updates when they aren't needed anymore
    self.locationManager.allowsBackgroundLocationUpdates = NO;
    
}
 */

@end
