//
//  JJCommandTime.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandTime.h"
#import "JJCommandParam.h"
#import "JJFormat.h"

@implementation JJCommandTime

+ (NSData *)currentTime{
    
    NSMutableData* mutableTimeData = [NSMutableData data];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];
    WORD yearbyte = [self getTimeToShort:year];
    [mutableTimeData appendBytes:&yearbyte length:2];
    
    NSInteger month = [comps month];
    BYTE monthbyte = [self getTimeToByte:month];
    [mutableTimeData appendBytes:&monthbyte length:1];
    
    NSInteger day = [comps day];
    BYTE daybyte = [self getTimeToByte:day];
    [mutableTimeData appendBytes:&daybyte length:1];
    
    NSInteger hour = [comps hour];
    BYTE hourbyte = [self getTimeToByte:hour];
    [mutableTimeData appendBytes:&hourbyte length:1];
    
    NSInteger min = [comps minute];
    BYTE minbyte = [self getTimeToByte:min];
    [mutableTimeData appendBytes:&minbyte length:1];
    
    NSInteger sec = [comps second];
    BYTE secbyte = [self getTimeToByte:sec];
    [mutableTimeData appendBytes:&secbyte length:1];
    
    BYTE RFU = 0x00;
    [mutableTimeData appendBytes:&RFU length:1];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec]);
    
    return mutableTimeData;
}

+ (WORD)getTimeToShort:(NSInteger)decimal{
    NSString *string = [JJFormat formatToHexadecimalStringWithDecimalNSUInteger:decimal];
    return strtoul([string UTF8String],0,16);// 结果字节为2字节
}

+ (BYTE)getTimeToByte:(NSInteger)decimal{
    NSString *string = [JJFormat formatToHexadecimalStringWithDecimalNSUInteger:decimal];
    return strtoul([string UTF8String],0,16);
}


@end
