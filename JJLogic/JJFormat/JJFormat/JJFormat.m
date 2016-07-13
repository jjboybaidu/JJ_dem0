//
//  JJFormat.m
//  JJFormat
//
//  Created by farbell-imac on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJFormat.h"
static NSMutableDictionary *_bitHexDic;
static NSMutableDictionary *_tenHexDic;
static NSMutableDictionary *_bitQDic;

@implementation JJFormat

// Usally Use
/*
 
 // NSData Change to Decimal String,the ansult is string
 + (NSString*)formatToDecimalStringWithNSData:(NSData*)data;
 
 // NSData change to long long value,the ansult is unsigned long long
 + (unsigned long long)formatToLongLongValueWithNSData:(NSData*)data
 
 // Hexadecimal change to NSData,the ansult is
 + (NSData *)formatToNSDataWithHexadecimalString:(NSString *)string;
 
 // Format current time to NSData
 + (NSData *)formatTotNSDataTimeWithCurrentTime;
 
 */

+ (unsigned long long)formatToLongLongValueWithNSData:(NSData*)data{
    NSString *stringHex = [self formatToHexadecimalStringWithNSData:data];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    unsigned long long longLongValue = [[formatter numberFromString:stringHex]unsignedLongLongValue];
    return longLongValue;
}

+ (NSString*)formatToDecimalStringWithNSData:(NSData*)data{
    return [self formatToDecimalStringWithHexadecimalString:[self formatToHexadecimalStringWithNSData:data]];
}

+ (NSData *)formatToNSDataWithHexadecimalString:(NSString *)string{
    NSMutableData* data = [NSMutableData data];
    for (int idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

#if 0
+ (NSData *)HexadecimalToNSData:(NSString *)str {
    if (!str || [str length] == 0) return nil;
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}
#endif

+ (NSString *)formatToHexadecimalStringWithNSData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

+ (NSString *)formatToDecimalStringWithBinaryString:(NSString *)string{
    NSUInteger decimal = 0;
    for (NSInteger index = 0; index < string.length; index++) {
        double num = [[string substringWithRange:(NSRange){string.length - index - 1, 1}] doubleValue];
        decimal +=  num * pow(2, index);
    }
    return [NSString stringWithFormat:@"%ld", (unsigned long)decimal];
}

+ (NSString *)formatToOctalStringWithBinaryString:(NSString *)string{
    return [self formatToOctalStringWithDecimalNSUInteger:[[self formatToDecimalStringWithBinaryString:string] integerValue]];
}

+ (NSString *)formatToHexadecimalStringWithBinaryString:(NSString *)string{
    return [self formatToHexadecimalStringWithDecimalNSUInteger:[[self formatToDecimalStringWithBinaryString:string] integerValue]];
}

+ (NSString *)formatToBinaryStringWithOctalString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = string.length;
    for (NSInteger index = 0; index < count; index++) {
        NSString *appendStr = [[self bitQDic] objectForKey:[string substringWithRange:(NSRange){index, 1}]];
        if(index == 0){
            appendStr = [NSString stringWithFormat:@"%ld", (long)[appendStr integerValue]];
        }
        if (appendStr) {
            [str appendString:appendStr];
        }
    }
    return str;
}

+ (NSString *)formatToDecimalStringWithOctalString:(NSString *)string{
    return [self formatToDecimalStringWithBinaryString:[self formatToBinaryStringWithOctalString:string]];
}

+ (NSString *)formatToHexadecimalStringWithOctalString:(NSString *)string{
    return [self formatToHexadecimalStringWithBinaryString:[self formatToBinaryStringWithOctalString:string]];
}

+ (NSString *)formatTenToOtherWithNumString:(NSUInteger)num system:(NSUInteger)system{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    while (num){
        [str insertString:[NSString stringWithFormat:@"%lu", num % system] atIndex:0];
        num /= system;
    }
    return str;
}

+ (NSString *)formatToBinaryStringWithDecimalNSUInteger:(NSUInteger)nsuinteger{
    return [self formatTenToOtherWithNumString:nsuinteger system:2];
}

+ (NSString *)formatToOctalStringWithDecimalNSUInteger:(NSUInteger)nsuinteger{
    return [self formatTenToOtherWithNumString:nsuinteger system:8];
}

+ (NSString *)formatToHexadecimalStringWithDecimalNSUInteger:(NSUInteger)nsuinteger{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    while (nsuinteger) {
        [str insertString:[[self tenHexDic] objectForKey:[NSString stringWithFormat:@"%lu", nsuinteger % 16]] atIndex:0];
        nsuinteger /= 16;
    }
    return str;
}

+ (NSString *)formatToBinaryStringWithHexadecimalString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = string.length;
    for (NSInteger index = 0; index < count; index++) {
        NSString *appendStr = [[self bitHexDic] objectForKey:[string substringWithRange:(NSRange){index, 1}]];
        if(index == 0){
            appendStr = [NSString stringWithFormat:@"%ld", (long)[appendStr integerValue]];
        }
        if (appendStr) {
            [str appendString:appendStr];
        }
    }
    return str;
}

+ (NSString *)formatToOctalStringWithHexadecimalString:(NSString *)string{
    
    return [self formatToOctalStringWithBinaryString:[self formatToBinaryStringWithHexadecimalString:string]];
}

+ (NSString *)formatToDecimalStringWithHexadecimalString:(NSString *)string {
    
    return [self formatToDecimalStringWithBinaryString:[self formatToBinaryStringWithHexadecimalString:string]];
}

+ (NSMutableDictionary *)bitHexDic{
    if(_bitHexDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        [hex setObject:@"0000" forKey:@"0"];
        [hex setObject:@"0001" forKey:@"1"];
        [hex setObject:@"0010" forKey:@"2"];
        [hex setObject:@"0011" forKey:@"3"];
        [hex setObject:@"0100" forKey:@"4"];
        [hex setObject:@"0101" forKey:@"5"];
        [hex setObject:@"0110" forKey:@"6"];
        [hex setObject:@"0111" forKey:@"7"];
        [hex setObject:@"1000" forKey:@"8"];
        [hex setObject:@"1001" forKey:@"9"];
        [hex setObject:@"1010" forKey:@"A"];
        [hex setObject:@"1011" forKey:@"B"];
        [hex setObject:@"1100" forKey:@"C"];
        [hex setObject:@"1101" forKey:@"D"];
        [hex setObject:@"1110" forKey:@"E"];
        [hex setObject:@"1111" forKey:@"F"];
        [hex setObject:@"1010" forKey:@"a"];
        [hex setObject:@"1011" forKey:@"b"];
        [hex setObject:@"1100" forKey:@"c"];
        [hex setObject:@"1101" forKey:@"d"];
        [hex setObject:@"1110" forKey:@"e"];
        [hex setObject:@"1111" forKey:@"f"];
        _bitHexDic = hex;
    }
    return _bitHexDic;
}

+ (NSMutableDictionary *)tenHexDic{
    if(_tenHexDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        [hex setObject:@"0" forKey:@"0"];
        [hex setObject:@"1" forKey:@"1"];
        [hex setObject:@"2" forKey:@"2"];
        [hex setObject:@"3" forKey:@"3"];
        [hex setObject:@"4" forKey:@"4"];
        [hex setObject:@"5" forKey:@"5"];
        [hex setObject:@"6" forKey:@"6"];
        [hex setObject:@"7" forKey:@"7"];
        [hex setObject:@"8" forKey:@"8"];
        [hex setObject:@"9" forKey:@"9"];
        [hex setObject:@"A" forKey:@"10"];
        [hex setObject:@"B" forKey:@"11"];
        [hex setObject:@"C" forKey:@"12"];
        [hex setObject:@"D" forKey:@"13"];
        [hex setObject:@"E" forKey:@"14"];
        [hex setObject:@"F" forKey:@"15"];
        [hex setObject:@"a" forKey:@"10"];
        [hex setObject:@"b" forKey:@"11"];
        [hex setObject:@"c" forKey:@"12"];
        [hex setObject:@"d" forKey:@"13"];
        [hex setObject:@"e" forKey:@"14"];
        [hex setObject:@"f" forKey:@"15"];
        _tenHexDic = hex;
    }
    return _tenHexDic;
}

+ (NSMutableDictionary *)bitQDic{
    if(_bitQDic == nil){
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:8];
        [hex setObject:@"000" forKey:@"0"];
        [hex setObject:@"001" forKey:@"1"];
        [hex setObject:@"010" forKey:@"2"];
        [hex setObject:@"011" forKey:@"3"];
        [hex setObject:@"100" forKey:@"4"];
        [hex setObject:@"101" forKey:@"5"];
        [hex setObject:@"110" forKey:@"6"];
        [hex setObject:@"111" forKey:@"7"];
        _bitQDic = hex;
    }
    return _bitQDic;
}

// Format current time to NSData Time
+ (NSData *)formatTotNSDataTimeWithCurrentTime{
    NSMutableData* mutableTimeData = [NSMutableData data];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];
    unsigned short yearbyte = [self getTimeToShort:year];
    [mutableTimeData appendBytes:&yearbyte length:2];
    
    NSInteger month = [comps month];
    unsigned char monthbyte = [self getTimeToByte:month];
    [mutableTimeData appendBytes:&monthbyte length:1];
    
    NSInteger day = [comps day];
    unsigned char daybyte = [self getTimeToByte:day];
    [mutableTimeData appendBytes:&daybyte length:1];
    
    NSInteger hour = [comps hour];
    unsigned char hourbyte = [self getTimeToByte:hour];
    [mutableTimeData appendBytes:&hourbyte length:1];
    
    NSInteger min = [comps minute];
    unsigned char minbyte = [self getTimeToByte:min];
    [mutableTimeData appendBytes:&minbyte length:1];
    
    NSInteger sec = [comps second];
    unsigned char secbyte = [self getTimeToByte:sec];
    [mutableTimeData appendBytes:&secbyte length:1];
    
    unsigned char RFU = 0x00;
    [mutableTimeData appendBytes:&RFU length:1];
    
    return mutableTimeData;
}

+ (unsigned short)getTimeToShort:(NSInteger)decimal{
    NSString *string = [self formatToHexadecimalStringWithDecimalNSUInteger:decimal];
    return strtoul([string UTF8String],0,16);
}

+ (unsigned char)getTimeToByte:(NSInteger)decimal{
    NSString *string = [self formatToHexadecimalStringWithDecimalNSUInteger:decimal];
    return strtoul([string UTF8String],0,16);
}

// Format NSData time to current time
+ (void)formatToCurrentTimeWithNSDataTime:(NSData*)data{
    if (data.length == 8) {
        unsigned short yearData ;
        [data getBytes:&yearData range:NSMakeRange(0, 2)];
        NSData *monthData = [data subdataWithRange:NSMakeRange(2, 1)];
        NSData *dayData = [data subdataWithRange:NSMakeRange(3, 1)];
        NSData *hourData = [data subdataWithRange:NSMakeRange(4, 1)];
        NSData *minData = [data subdataWithRange:NSMakeRange(5, 1)];
        NSData *secondData = [data subdataWithRange:NSMakeRange(6, 1)];
        NSLog(@"Current Time is ：%d年%d月%d日%d时%d分%d秒",
              yearData,
              [self transfer:monthData],
              [self transfer:dayData],
              [self transfer:hourData],
              [self transfer:minData],
              [self transfer:secondData]);
    }else{
        NSLog(@"Length not right");
    }
}

//Transfer NSDataToHexadecimal ;and Transfer HexadeciamlToDeciaml
+ (int)transfer:(NSData*)data{
    NSString *decimal = [self formatToDecimalStringWithNSData:data];
    int result = decimal.intValue;
    return result;
}


@end
