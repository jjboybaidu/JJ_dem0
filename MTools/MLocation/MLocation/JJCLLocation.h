//
//  JJCLLocation.h
//  JJCLLocation
//
//  Created by ; on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCLLocation : NSObject
+ (instancetype)sharedInstance;
- (void)startUpdatingLocation;
@property(nonatomic,copy)NSString *name;

@end
