//
//  JJCLLocationDeferUpdate.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationDeferUpdate.h"

@implementation JJCLLocationDeferUpdate{
    BOOL _isBackgroundMode;
    BOOL _deferringUpdates;
}

-(void) initLocationManager
{
    // Create the manager object
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    // Request location authorization
    [self.locationManager requestWhenInUseAuthorization];
    
    // Enable background location updates
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    // Enable automatic pausing
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    _locationManager.desiredAccuracy = 45;
    _locationManager.distanceFilter = 100;
    
    // Once configured, the location manager must be "started".
    [_locationManager startUpdatingLocation];
    _isBackgroundMode = NO;
    _deferringUpdates = NO;
    
}

- (void)applicationWillResignActive {
    _isBackgroundMode = YES;
    
    [_locationManager stopUpdatingLocation];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [_locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //  store data
    NSLog(@"位置有更新");
    CLLocation *newLocation = [locations lastObject];
    self.userLocation = newLocation;
    
    //tell the centralManager that you want to deferred this updatedLocation
    if (_isBackgroundMode && !_deferringUpdates)
    {
        _deferringUpdates = YES;
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:10];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    NSLog(@"结束延迟更新");
    _deferringUpdates = NO;
    
    //do something
}






/*
 
 -(void)startHikeLocationUpdates {
 // Create a location manager object
 self.locationManager = [[CLLocationManager alloc] init];
 
 // Set the delegate
 self.locationManager.delegate = self;
 
 // Request location authorization
 [self.locationManager requestWhenInUseAuthorization];
 
 // Specify the type of activity your app is currently performing
 self.locationManager.activityType = CLActivityTypeFitness;
 
 // Start location updates
 [self.locationManager startUpdatingLocation];
 }
 
 
 -(void)locationManager:(CLLocationManager *)manager
 didUpdateLocations:(NSArray *)locations {
 // Add the new locations to the hike
 [self.hike addLocations:locations];
 
 // Defer updates until the user hikes a certain distance or a period of time has passed
 if (!self.deferringUpdates) {
 CLLocationDistance distance = self.hike.goal - self.hike.distance;
 NSTimeInterval time = [self.nextUpdate timeIntervalSinceNow];
 [self.locationManager allowDeferredLocationUpdatesUntilTraveled:distance timeout:time];
 self.deferringUpdates = YES;
 }
 
 }
 
 
 -(void)locationManager:(CLLocationManager *)manager
 didFinishDeferredUpdatesWithError:(NSError *)error {
 // Stop deferring updates
 // self.deferringUpdates = NO;
 
 // Adjust for the next goal
 }
 
 */

@end
