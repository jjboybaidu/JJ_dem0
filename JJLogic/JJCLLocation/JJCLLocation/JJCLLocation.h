//
//  JJCLLocation.h
//  JJCLLocation
//
//  Created by farbell-imac on 16/7/30.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocation : NSObject<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager * locMgr;
@property (weak, nonatomic) IBOutlet UILabel *locLab;
@end
