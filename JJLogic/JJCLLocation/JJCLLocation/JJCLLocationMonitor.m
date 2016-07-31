//
//  JJCLLocationMonitor.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationMonitor.h"

@implementation JJCLLocationMonitor

-(void)startVisitMonitoring {
    // Create a location manager object
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Set the delegate
    self.locationManager.delegate = self;
    
    // Request location authorization
    [self.locationManager requestAlwaysAuthorization];
    
    // Start monitoring for visits
    [self.locationManager startMonitoringVisits];
}

-(void)stopVisitMonitoring {
    [self.locationManager stopMonitoringVisits];
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    // Perform location-based activity
    
}

@end
