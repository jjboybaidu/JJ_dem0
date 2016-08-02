//
//  JJCLLocationGeocode.h
//  JJCLLocation
//
//  Created by WilliamLiuWen on 16/8/2.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCLLocationGeocode : NSObject
+ (id)sharedInstance;
- (void)geocode:(NSString *)addressString;
- (void)reverseGeocode:(NSArray *)locations;

@end
