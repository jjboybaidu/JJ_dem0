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

// Format DecimalNSUInteger to HexadecimalString
+ (NSString *)formatToHexadecimalStringWithDecimalNSUInteger:(NSUInteger)nsuinteger;

// Format HexadecimalString to DecimalString
+ (NSString *)formatToDecimalStringWithHexadecimalString:(NSString *)string ;

@end
