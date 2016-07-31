//
//  JJCLLocationQuickUpdate.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationQuickUpdate.h"

@implementation JJCLLocationQuickUpdate

// 1.快速更新位置信息，省电
-(void)getQuickLocationUpdate {
    // Create a location manager object
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the delegate
    self.locationManager.delegate = self;
    
    // Request location authorization
    [self.locationManager requestWhenInUseAuthorization];
    
    // Set an accuracy level. The higher, the better for energy.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    // Request a location update
    [self.locationManager requestLocation];
    // Note: requestLocation may timeout and produce an error if authorization has not yet been granted by the user
    
    // Start location updates
    [self.locationManager startUpdatingLocation];
    
}

@end
