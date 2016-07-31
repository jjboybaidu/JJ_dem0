//
//  JJCLLocationDeferUpdate.h
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocationDeferUpdate : NSObject<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)CLLocation *userLocation;
-(void) initLocationManager;
- (void)applicationWillResignActive;
@end
