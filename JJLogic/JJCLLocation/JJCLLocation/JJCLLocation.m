//
//  JJCLLocation.m
//  JJCLLocation
//
//  Created by farbell-imac on 16/7/30.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocation.h"
#import "JJCLLocationDeferUpdate.h"
#import "JJCLLocationBackGround.h"

@implementation JJCLLocation{
    JJCLLocationDeferUpdate *deferupdateLocationManager;
    JJCLLocationBackGround *locationBackGround;
}

-(void)setupJJCLLocationManager {
    
    // setupLocationBackGround
    [self setupLocationBackGround];
}

// setupLocationBackGround
- (void)setupLocationBackGround{
    locationBackGround = [JJCLLocationBackGround sharedInstance];
    [locationBackGround startUpdatingLocation];
}

// setupDeferupdateLocationManager
- (void)setupDeferupdateLocationManager{
    deferupdateLocationManager = [[JJCLLocationDeferUpdate alloc]init];
    [deferupdateLocationManager initLocationManager];
}
- (void)enterBackGround{
    [deferupdateLocationManager applicationWillResignActive];
}









/*
 
 // 判断获取的位置信息，是不是前15秒前的，而不是缓存里面的。
 // Delegate method from the CLLocationManagerDelegate protocol.
 - (void)locationManager:(CLLocationManager *)manager
 didUpdateLocations:(NSArray *)locations {
 // If it's a relatively recent event, turn off updates to save power.
 CLLocation* location = [locations lastObject];
 NSDate* eventDate = location.timestamp;
 NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
 if (abs(howRecent) < 15.0) {
 // If the event is recent, do something with it.
 NSLog(@"latitude %+.6f, longitude %+.6f\n",
 location.coordinate.latitude,
 location.coordinate.longitude);
 }
 }
 
 */

@end
