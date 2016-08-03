//
//  JJCommandANTask.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandANTask.h"
#import "JJCommandNotification.h"
#import "JJFormat.h"
#import "JJCommandSender.h"
#import "JJCommandX.h"

@interface JJCommandANTask()
@property (nonatomic,strong)JJCommandSender *sender;

@end

@implementation JJCommandANTask

- (NSArray *)array{
    if (_array == nil) {
        _array = [NSArray array];
    }
    return _array;
}

+ (instancetype) getInstance{
    static JJCommandANTask* _instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        _instance = [[JJCommandANTask alloc] init];
    });
    return _instance;
}

- (void)setupCommandAN{
    self.sender = [JJCommandSender getInstance];
    [self.sender setupSender];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enumTaskTableforReceiver:) name:NOTIFICATION_SUCCESS object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endSendAN) name:NOTIFICATION_START_END_SENDING_AN object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAN) name:NOTIFICATION_START_SENDING_AN object:nil];
}

- (void)sendANWithSourceID:(DWORD)sourceID targetID:(DWORD)targetID dely:(float)dely maxSendNum:(int)maxSendNum host:(NSString *)host port:(uint16_t)port{
    // 发送请求设置通道号命令
    NSMutableData *startData = [NSMutableData data];
    WORD countAN = self.array.count;
    [startData appendBytes:&countAN length:2];
    WORD sumPacket = self.array.count / 25 + 1;
    [startData appendBytes:&sumPacket length:2];
    WORD maxSN = sumPacket + 2000;
    //    [self sendAN];
    [self sendStartCommandWithData:startData host:host port:port SN:2000  SourceID:sourceID targetID:targetID  dely:1.5 maxSendNum:maxSendNum ];
    
    //    if ([array count] < 25 && [array count] > 0) {
    //        NSData *data = [self lessArray:array];
    //        [self sendStartCommandWithData:data host:host port:port SN:2000  SourceID:sourceID targetID:targetID  dely:dely maxSendNum:maxSendNum ];
    //    }else if([array count] > 25){
    //        NSArray *dataarray = [self moreArray:array];
    //        [self sendStartCommandWithData:data host:host port:port SN:2000  SourceID:sourceID targetID:targetID  dely:dely maxSendNum:maxSendNum ] ;
    //    }
    //}
    
}

- (void)sendAN:(NSNotification *)notification{
    NSData *notificationData = notification.object;
    
    BYTE INS = [[JJCommandX getInstance] getINS:notificationData];
    WORD SN = [[JJCommandX getInstance] getSN:notificationData];
    BYTE P1 = [[JJCommandX getInstance] getP1:notificationData];
    BYTE P2 = [[JJCommandX getInstance] getP2:notificationData];
    NSLog(@"INS = %d SN = %d P1 = %d P1 = %d",INS,SN,P1,P2);
    if (SN == 2000) {
        NSData *data = [self lessArray:self.array];
        //    NSLog(@"%@",data);
        [self sendingCommandWithData:data host:@"192.168.0.1" port:6000 SN:2001  SourceID:0x00 targetID:0x00  dely:3 maxSendNum:3 ];
    }else if (SN == 2001){
        NSMutableData *endSendingData = [NSMutableData data];
        WORD sussesCode = 0x01;
        [endSendingData appendBytes:&sussesCode length:2];
        [self endSendingCommandWithData:endSendingData host:@"192.168.0.1" port:6000 SN:2002  SourceID:0x00 targetID:0x00  dely:3 maxSendNum:3 ];
    }
    
}

- (void)endSendAN{
    
}

- (void)sendStartCommandWithData:(NSData *)data host:(NSString*)host port:(uint16_t)port SN:(WORD)SN SourceID:(DWORD)sourceID targetID:(DWORD)targetID  dely:(float)dely maxSendNum:(int)maxSendNum {
    [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                             p1:0x00
                                             p2:0x00
                                             sn:SN
                                       sourceID:sourceID
                                       targetID:targetID
                                     defineData:data
                                           dely:dely
                                     maxSendNum:maxSendNum
                                           host:host
                                           port:port];
}

- (void)sendingCommandWithData:(NSData *)data host:(NSString*)host port:(uint16_t)port SN:(WORD)SN  SourceID:(DWORD)sourceID targetID:(DWORD)targetID  dely:(float)dely maxSendNum:(int)maxSendNum {
    [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                             p1:0x00
                                             p2:0x01
                                             sn:SN
                                       sourceID:sourceID
                                       targetID:targetID
                                     defineData:data
                                           dely:dely
                                     maxSendNum:maxSendNum
                                           host:host
                                           port:port];
}

- (void)endSendingCommandWithData:(NSData *)data host:(NSString*)host port:(uint16_t)port SN:(WORD)SN  SourceID:(DWORD)sourceID targetID:(DWORD)targetID  dely:(float)dely maxSendNum:(int)maxSendNum {
    [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                             p1:0x00
                                             p2:0x02
                                             sn:SN
                                       sourceID:sourceID
                                       targetID:targetID
                                     defineData:data
                                           dely:dely
                                     maxSendNum:maxSendNum
                                           host:host
                                           port:port];
}

- (NSData *)lessArray:(NSArray *)array{
    NSMutableData *data = [NSMutableData dataWithCapacity:25];
    WORD  numPacket = 0x01;
    [data appendBytes:&numPacket length:2];
    NSInteger count = array.count;
    WORD idLength = 8 * count;
    [data appendBytes:&idLength length:2];
    for (NSString * string in array) {
        [data appendData:[self dataLocalID:string]];
    }
    return data;
}

- (NSArray *)moreArray:(NSArray *)array{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:25];
    float subArrayCount = ([array count] / 25);// 如果是31，结果就是1；如果是51，结果就是2；
    int lastArrayLength = ([array count]%25);// 如果是31，结果就是6；如果是51，结果就是1；
    for (int i =0 ; i < subArrayCount; i ++) {
        NSMutableData *subData = [NSMutableData dataWithCapacity:25];
        WORD numPacket = i;
        [subData appendBytes:&numPacket length:2];
        WORD idLength = 8 * 25;
        [subData appendBytes:&idLength length:2];
        NSArray *subArray = [array subarrayWithRange:NSMakeRange(i * 25, 25)];
        for (NSString *string  in subArray) {
            [subData appendData:[self dataLocalID:string]];
        }
        [dataArray addObject:subData];
    }
    NSMutableData *lastsubData = [NSMutableData dataWithCapacity:1];
    WORD numPacket = subArrayCount;
    [lastsubData appendBytes:&numPacket length:2];
    WORD idLength = 8*lastArrayLength;
    [lastsubData appendBytes:&idLength length:2];
    NSArray *subArray = [array subarrayWithRange:NSMakeRange(subArrayCount * 25, lastArrayLength)];
    for (NSString *string  in subArray) {
        [lastsubData appendData:[self dataLocalID:string]];
    }
    [dataArray addObject:lastsubData];
    return dataArray;
}

- (NSData *)dataLocalID:(NSString *)idString{
    if ([idString length] == 16) {
        NSMutableData* localidData = [NSMutableData data];
        
        NSString *id1String = [idString substringWithRange:NSMakeRange(0, 2)];
        NSString *decimalString = [JJFormat formatToDecimalStringWithHexadecimalString:id1String];
        unsigned char id1char = [decimalString intValue];
        unsigned char id1 = id1char;
        [localidData appendBytes:&id1 length:1];
        
        NSString *id2String = [idString substringWithRange:NSMakeRange(2, 2)];
        NSString *decimal2String = [JJFormat formatToDecimalStringWithHexadecimalString:id2String];
        unsigned char id2char = [decimal2String intValue];
        unsigned char id2 = id2char;
        [localidData appendBytes:&id2 length:1];
        
        NSString *id3String = [idString substringWithRange:NSMakeRange(4, 2)];
        NSString *decimal3String = [JJFormat formatToDecimalStringWithHexadecimalString:id3String];
        unsigned char id3char = [decimal3String intValue];
        unsigned char id3 = id3char;
        [localidData appendBytes:&id3 length:1];
        
        NSString *id4String = [idString substringWithRange:NSMakeRange(6, 2)];
        NSString *decimal4String = [JJFormat formatToDecimalStringWithHexadecimalString:id4String];
        unsigned char id4char = [decimal4String intValue];
        unsigned char id4 = id4char;
        [localidData appendBytes:&id4 length:1];
        
        NSString *id5String = [idString substringWithRange:NSMakeRange(8, 2)];
        NSString *decimal5String = [JJFormat formatToDecimalStringWithHexadecimalString:id5String];
        unsigned char id5char = [decimal5String intValue];
        unsigned char id5 = id5char;
        [localidData appendBytes:&id5 length:1];
        
        NSString *id6String = [idString substringWithRange:NSMakeRange(10, 2)];
        NSString *decimal6String = [JJFormat formatToDecimalStringWithHexadecimalString:id6String];
        unsigned char id6char = [decimal6String intValue];
        unsigned char id6 = id6char;
        [localidData appendBytes:&id6 length:1];
        
        NSString *id7String = [idString substringWithRange:NSMakeRange(12, 2)];
        NSString *decimal7String = [JJFormat formatToDecimalStringWithHexadecimalString:id7String];
        unsigned char id7char = [decimal7String intValue];
        unsigned char id7 = id7char;
        [localidData appendBytes:&id7 length:1];
        
        NSString *id8String = [idString substringWithRange:NSMakeRange(14, 2)];
        NSString *decimal8String = [JJFormat formatToDecimalStringWithHexadecimalString:id8String];
        unsigned char id8char = [decimal8String intValue];
        unsigned char id8 = id8char;
        [localidData appendBytes:&id8 length:1];
        
        return localidData;
    }else{
        NSLog(@"Local ID String长度不对");
        return nil;
    }
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}


































































#if 0

- (void)initWithAccessNum{
    mySender *sender = [mySender getInstance];
    self.sender = sender;
    [self.sender setupSender];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAccNumber) name:SuccessResponseCodeNotification object:nil];
}

- (void)sendAccessNumWithp1:(BYTE)p1Value
                         p2:(BYTE)p2Value
                         sn:(WORD)snValue
                   sourceID:(DWORD)sourceIDValue
                   targetID:(DWORD)targetIDValue
                       dely:(float)delyValue
                 maxSendNum:(int)maxSendNumValue
                       host:(NSString *)host
                       port:(uint16_t)port
                      array:(NSArray *)array{
    
    if ([array count] < 25 && [array count] > 0) {
        NSData *data = [self emuAccessNumArray:array];
        [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                                 p1:p1Value
                                                 p2:p2Value
                                                 sn:snValue
                                           sourceID:sourceIDValue
                                           targetID:targetIDValue
                                         defineData:data
                                               dely:delyValue
                                         maxSendNum:maxSendNumValue
                                               host:host
                                               port:port];
        
    }else if([array count] > 25){
        NSArray *dataarray = [self emuAccessNumArrayBackArray:array];
        for (int i = 0; i < dataarray.count; i ++) {
            snValue = 200+i;
            [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                                     p1:p1Value
                                                     p2:p2Value
                                                     sn:snValue
                                               sourceID:sourceIDValue
                                               targetID:targetIDValue
                                             defineData:data
                                                   dely:delyValue
                                             maxSendNum:maxSendNumValue
                                                   host:host
                                                   port:port];
            [NSThread sleepForTimeInterval:0.05];
        }
        
        for (NSData *data in dataarray) {
            NSInteger count = dataarray.count;
            snValue = snValue +1;
            [self.sender setCommonSendTaskWithPacketIns:INS_SET_ACCNUM
                                                     p1:p1Value
                                                     p2:p2Value
                                                     sn:snValue
                                               sourceID:sourceIDValue
                                               targetID:targetIDValue
                                             defineData:data
                                                   dely:delyValue
                                             maxSendNum:maxSendNumValue
                                                   host:host
                                                   port:port];
            [NSThread sleepForTimeInterval:0.05];
        }
    }
}

/*
 * 设置AccessNum情况1：小于25个
 */
- (NSData *)emuAccessNumArray:(NSArray *)array{
    NSMutableData *data = [NSMutableData dataWithCapacity:25];
    WORD  numPacket = 0x01;
    [data appendBytes:&numPacket length:2];
    NSInteger count = array.count;
    WORD idLength = 8 * count;
    [data appendBytes:&idLength length:2];
    for (NSString * string in array) {
        
        [data appendData:[self dataLocalID:string]];
    }
    return data;
}

/*
 * 设置AccessNum情况2：大于25个
 */
- (NSArray *)emuAccessNumArrayBackArray:(NSArray *)array{
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:25];
    
    float subArrayCount = ([array count] / 25);// 如果是31，结果就是1；如果是51，结果就是2；
    int lastArrayLength = ([array count]%25);// 如果是31，结果就是6；如果是51，结果就是1；
    //    NSLog(@"subArrayCount___%f",subArrayCount);
    //    NSLog(@"lastArrayLength___%d",lastArrayLength);
    
    for (int i =0 ; i < subArrayCount; i ++) {
        
        NSMutableData *subData = [NSMutableData dataWithCapacity:25];
        WORD numPacket = i;
        //        WORD numPacket = 25;// 2
        [subData appendBytes:&numPacket length:2];
        
        WORD idLength = 8 * 25;
        //        WORD idLength = 0x08;// 2
        [subData appendBytes:&idLength length:2];
        
        NSArray *subArray = [array subarrayWithRange:NSMakeRange(i * 25, 25)];
        for (NSString *string  in subArray) {
            [subData appendData:[self dataLocalID:string]];
        }
        [dataArray addObject:subData];
        
    }
    
    NSMutableData *lastsubData = [NSMutableData dataWithCapacity:1];
    WORD numPacket = subArrayCount;
    //    WORD numPacket = lastArrayLength;// 2
    [lastsubData appendBytes:&numPacket length:2];
    
    WORD idLength = 8*lastArrayLength;
    //    WORD idLength = 0x08;// 2
    [lastsubData appendBytes:&idLength length:2];
    NSArray *subArray = [array subarrayWithRange:NSMakeRange(subArrayCount * 25, lastArrayLength)];
    for (NSString *string  in subArray) {
        [lastsubData appendData:[self dataLocalID:string]];
    }
    [dataArray addObject:lastsubData];
    
    return dataArray;
}

- (NSData *)dataLocalID:(NSString *)idString{
    if ([idString length] == 16) {
        NSMutableData* localidData = [NSMutableData data];
        
        NSString *id1String = [idString substringWithRange:NSMakeRange(0, 2)];
        NSString *decimalString = [myDataFormat HexadecimalToDecimal:id1String];
        unsigned char id1char = [decimalString intValue];
        unsigned char id1 = id1char;
        [localidData appendBytes:&id1 length:1];
        
        NSString *id2String = [idString substringWithRange:NSMakeRange(2, 2)];
        NSString *decimal2String = [myDataFormat HexadecimalToDecimal:id2String];
        unsigned char id2char = [decimal2String intValue];
        unsigned char id2 = id2char;
        [localidData appendBytes:&id2 length:1];
        
        NSString *id3String = [idString substringWithRange:NSMakeRange(4, 2)];
        NSString *decimal3String = [myDataFormat HexadecimalToDecimal:id3String];
        unsigned char id3char = [decimal3String intValue];
        unsigned char id3 = id3char;
        [localidData appendBytes:&id3 length:1];
        
        NSString *id4String = [idString substringWithRange:NSMakeRange(6, 2)];
        NSString *decimal4String = [myDataFormat HexadecimalToDecimal:id4String];
        unsigned char id4char = [decimal4String intValue];
        unsigned char id4 = id4char;
        [localidData appendBytes:&id4 length:1];
        
        NSString *id5String = [idString substringWithRange:NSMakeRange(8, 2)];
        NSString *decimal5String = [myDataFormat HexadecimalToDecimal:id5String];
        unsigned char id5char = [decimal5String intValue];
        unsigned char id5 = id5char;
        [localidData appendBytes:&id5 length:1];
        
        NSString *id6String = [idString substringWithRange:NSMakeRange(10, 2)];
        NSString *decimal6String = [myDataFormat HexadecimalToDecimal:id6String];
        unsigned char id6char = [decimal6String intValue];
        unsigned char id6 = id6char;
        [localidData appendBytes:&id6 length:1];
        
        NSString *id7String = [idString substringWithRange:NSMakeRange(12, 2)];
        NSString *decimal7String = [myDataFormat HexadecimalToDecimal:id7String];
        unsigned char id7char = [decimal7String intValue];
        unsigned char id7 = id7char;
        [localidData appendBytes:&id7 length:1];
        
        NSString *id8String = [idString substringWithRange:NSMakeRange(14, 2)];
        NSString *decimal8String = [myDataFormat HexadecimalToDecimal:id8String];
        unsigned char id8char = [decimal8String intValue];
        unsigned char id8 = id8char;
        [localidData appendBytes:&id8 length:1];
        
        return localidData;
    }else{
        NSLog(@"Local ID String长度不对");
        return nil;
    }
}

#endif


@end
