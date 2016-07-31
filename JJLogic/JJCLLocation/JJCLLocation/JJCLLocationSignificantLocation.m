//
//  JJCLLocationSignificantLocation.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationSignificantLocation.h"

@implementation JJCLLocationSignificantLocation

-(void)startSignificantChangeLocationUpdates {
    // Create a location manager object
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the delegate
    self.locationManager.delegate = self;
    
    // Request location authorization
    [self.locationManager requestAlwaysAuthorization];
    
    // Start significant-change location updates
    [self.locationManager startMonitoringSignificantLocationChanges];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Perform location-based activity
    
    // Stop significant-change location updates when they aren't needed anymore
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

@end
