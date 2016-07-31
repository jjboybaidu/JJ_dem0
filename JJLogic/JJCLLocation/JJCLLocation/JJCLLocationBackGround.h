//
//  JJCLLocationBackGround.h
//  JJCLLocation
//
//  Created by ; on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocationBackGround : NSObject<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locationManager;
+ (instancetype)sharedInstance;
- (void)startUpdatingLocation;
@end
