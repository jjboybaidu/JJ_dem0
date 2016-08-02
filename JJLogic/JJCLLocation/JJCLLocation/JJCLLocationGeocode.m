//
//  JJCLLocationGeocode.m
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/8/2.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCLLocationGeocode.h"
#import <CoreLocation/CoreLocation.h>

@interface JJCLLocationGeocode()
@property(nonatomic,strong)CLGeocoder *geocoder;

@end

@implementation JJCLLocationGeocode

+ (id)sharedInstance {
    static JJCLLocationGeocode *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (CLGeocoder *)geocoder{
    if (_geocoder==nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

// Geocode地理编码 地名-->坐标
- (void)geocode:(NSString *)addressString{
    
    [self.geocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            NSLog(@"你输入的地址在月球吗？");
        }else{
            //取出获取的地理信息数组中的第一个显示在界面上
           CLPlacemark *firstPlacemark=[placemarks firstObject];
           //纬度
           CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;
           //经度
           CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
            NSLog(@"%@ - %@",[NSString stringWithFormat:@"%.2f",latitude],[NSString stringWithFormat:@"%.2f",longitude]);
       
        }
    }];
    
}

// reverse Geocode反地理编码 坐标-->地名
- (void)reverseGeocode:(NSArray *)locations{
    
    [self.geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error || placemarks.count == 0 ) {
            NSLog(@"此地理位置无法反编码");
        }else{
            for (CLPlacemark *placemark in placemarks) {
                // NSLog(@"name=%@ locality=%@ country=%@ postCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
                
                NSLog(@"\n name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n locality:%@\n subLocality:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                      placemark.name,                  //位置名
                      placemark.country,               //国家
                      placemark.postalCode,            //邮编
                      placemark.ISOcountryCode,        //
                      placemark.ocean,                 //
                      placemark.inlandWater,           //
                      placemark.administrativeArea,    //省
                      placemark.subAdministrativeArea, //
                      placemark.locality,              //市
                      placemark.subLocality,           //区
                      placemark.thoroughfare,          //街道
                      placemark.subThoroughfare        //子街道
                      
                      );
            }
        }
    }];
    
}

@end
