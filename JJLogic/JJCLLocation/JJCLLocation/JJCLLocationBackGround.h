//
//  JJCLLocationBackGround.h
//  JJCLLocation
//
//  Created by ; on 16/7/31.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCLLocationBackGround : NSObject
+ (instancetype)sharedInstance;
- (void)startUpdatingLocation;

@end
