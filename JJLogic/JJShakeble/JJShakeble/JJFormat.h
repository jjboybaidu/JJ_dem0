//
//  JJFormat.h
//  JJFormat
//
//  Created by farbell-imac on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJFormat : NSObject

// Format current time to NSData
+ (NSData *)formatTotNSDataTimeWithCurrentTime;

// Format NSData time to current time
+ (void)formatToCurrentTimeWithNSDataTime:(NSData*)data;

+ (NSString *)formatToHexadecimalStringWithNSData:(NSData *)data;

@end
