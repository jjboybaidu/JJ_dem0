//
//  JJCommandX.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandX.h"

@implementation JJCommandX

+ (instancetype) getInstance{
    static JJCommandX* _instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        _instance = [[JJCommandX alloc] init];
    });
    return _instance;
}

- (NSData *)creatRequestCommandWithCLA:(BYTE)CLAValue
                                   Ins:(BYTE)insValue
                                    P1:(BYTE)p1Value
                                    P2:(BYTE)p2Value
                                    SN:(WORD)snValue
                              SourceID:(DWORD64)sourceIDValue
                              TargetID:(DWORD64)targetIDValue
                                 Falg1:(DWORD)falg1Value
                                 Falg2:(WORD)falg2Value
                            defineData:(NSData *)defineData{
    
    NSMutableData* mutableData = [NSMutableData data];
    //-header
    WORD header = 0xA5A5;
    [mutableData appendBytes:&header length:2];
    //-cla
    BYTE cla = CLAValue;
    [mutableData appendBytes:&cla length:1];
    //-INS
    BYTE INS = insValue;
    [mutableData appendBytes:&INS length:1];
    //-P1
    BYTE P1 = p1Value;
    [mutableData appendBytes:&P1 length:1];
    //-P2
    BYTE P2 = p2Value;
    [mutableData appendBytes:&P2 length:1];
    //-SN
    WORD SN = snValue;
    [mutableData appendBytes:&SN length:2];
    //-SourceID
    DWORD64 SourceID = sourceIDValue;
    [mutableData appendBytes:&SourceID length:8];
    //-TargetID
    DWORD64 TargetID = targetIDValue;
    [mutableData appendBytes:&TargetID length:8];
    //-FLAG1
    DWORD FLAG1 = falg1Value;
    [mutableData appendBytes:&FLAG1 length:4];
    //-FLAG2
    WORD FLAG2 = falg2Value;
    [mutableData appendBytes:&FLAG2 length:2];
    //-LC
    WORD LC;
    if (defineData == nil) {
        LC = 0X00;
    }else{
        LC = defineData.length;
    }
    [mutableData appendBytes:&LC length:2];
    //-defineData
    if (LC > 0) {
        [mutableData appendData:defineData];
    }
    //-crc
    BYTE crcData[32 + LC];
    [mutableData getBytes:crcData length:(32 + LC)];
    WORD  crc = [self CalcCRC8:crcData iLength:(32 + LC)];
    [mutableData appendBytes:&crc length:2];
    //-tailer
    WORD tailer = 0xA3A3;
    [mutableData appendBytes:&tailer length:2];
    return mutableData;
}

/*
 * 判断是否为标准命令
 */
- (BOOL)IScommand:(NSData*)data{
    if(data == nil){
        NSLog(@"数据为空");
        return NO;
    }
    
    if (data.length < 36) {
        NSLog(@"长度不够36");
        return NO;
    }
    
    WORD hearder;
    [data getBytes:&hearder range:NSMakeRange(0, 2)];
    if(hearder != 0xA5A5){
        NSLog(@"协议头有错");
        return NO;
    }
    
    WORD tailer;
    [data getBytes:&tailer range:NSMakeRange(data.length-2, 2)];
    if(tailer != 0xA3A3){
        NSLog(@"协议尾有错");
        return NO;
    }
    
    WORD   LC = [self getLC:data];
    if( (36 + LC) != data.length){
        NSLog(@"LC不对");
        return NO;
    }
    
    BYTE crcData[32 + LC];
    [data getBytes:crcData length:(32 + LC)];
    WORD  oldCrc = [self getCRC:data];
    WORD  newCrc = [self CalcCRC8:crcData iLength:(32 + LC)];
    if ( oldCrc != newCrc) {
        NSLog(@"校验CRC失败");
        return NO;
    }
    
    BYTE ins = [self getINS:data];
    if([self isValidIns:ins] == NO){
        NSLog(@"ins不认识");
        return NO;
    }
    
    return YES;
}

/*
 * 判断是否为成功响应码
 */
- (BOOL)IsSuccessResponseCode:(NSData *)data{
    WORD responseCode = [self getResposeCode:data];
    if (responseCode != SW_SUCCESS) return NO;
    return YES;
}

/*
 * 判断是否为请求命令
 */
- (BOOL)IsRequestCommand:(NSData *)data{
    if (![self IScommand:data]) return NO;
    BYTE CLA = [self getCLA:data];
    return (CLA & CLA_RESPONSE) == CLA_REQUEST ? YES : NO;
}

/*
 * 判断是否为响应命令
 */
- (BOOL)IsResponseCommand:(NSData *)data{
    BYTE CLA = [self getCLA:data];
    BOOL responseCommand = (CLA & CLA_RESPONSE) == CLA_RESPONSE ? YES : NO;
    if (!responseCommand) NSLog(@"非响应命令");
    return responseCommand;
}

- (BYTE)CalcCRC8:(BYTE *)pData iLength:(int)iLength{
    BYTE result = 0;
    for (int i = 0; i < iLength; ++i) {
        result = Crc8Table [ result ^ pData[i] ];//^异或
    }
    return ~result;//~表示按位否定
}

- (WORD)getHearder:(NSData*)data{
    WORD header;
    [data getBytes:&header range:NSMakeRange(0, 2)]; // 0 1
    return header;
}

- (BYTE)getCLA:(NSData*)data{
    BYTE cla;
    [data getBytes:&cla range:NSMakeRange(2, 1)]; // 2
    return cla;
}

- (BYTE)getINS:(NSData*)data{
    BYTE ins;
    [data getBytes:&ins range:NSMakeRange(3, 1)]; // 3
    return ins;
}

- (BYTE)getP1:(NSData*)data{
    BYTE p1;
    [data getBytes:&p1 range:NSMakeRange(4, 1)]; // 4
    return p1;
}

- (BYTE)getP2:(NSData*)data{
    BYTE p2;
    [data getBytes:&p2 range:NSMakeRange(5, 1)]; // 5
    return p2;
}

- (WORD)getSN:(NSData*)data{
    WORD sn;
    [data getBytes:&sn range:NSMakeRange(6, 2)]; // 6
    return sn;
}

- (DWORD64)getSourceID:(NSData*)data{
    DWORD64 sourceid;
    [data getBytes:&sourceid range:NSMakeRange(8, 8)]; // 8+16
    return sourceid;
}

- (DWORD64)getTargetID:(NSData*)data{
    DWORD64 targetid;
    [data getBytes:&targetid range:NSMakeRange(16, 8)]; //16+24
    return targetid;
    
}

- (DWORD)getFLAG1:(NSData*)data{
    DWORD flag;
    [data getBytes:&flag range:NSMakeRange(24, 4)];//24+28
    return flag;
}

- (WORD)getFLAG2:(NSData*)data{
    WORD flag2;
    [data getBytes:&flag2 range:NSMakeRange(28, 2)];//
    return flag2;
}

- (WORD)getLC:(NSData*)data{
    WORD datalen;
    [data getBytes:&datalen range:NSMakeRange(30, 2)];//
    return datalen;
}

- (NSData*)getData:(NSData*)data{
    WORD datalen;
    NSData* newData;
    datalen = [self getLC:data];
    newData = [data subdataWithRange:NSMakeRange(32, datalen)];
    return newData;
}

- (WORD)getCRC:(NSData*)data{
    WORD crc;
    [data getBytes:&crc range:NSMakeRange(data.length-4, 2)];
    return crc;
}

- (WORD)getTailer:(NSData*)data{
    WORD tailer;
    [data getBytes:&tailer range:NSMakeRange(data.length-2, 2)]; // 0 1
    return tailer;
}

- (WORD)getResposeCode:(NSData*)data{
    WORD response;
    [data getBytes:&response range:NSMakeRange(32, 2)];// 数据区前两个字节
    return response;
}

- (NSData*)getDataWithoutResposeCode:(NSData*)data{
    WORD datalen;
    NSData* newData;
    datalen = [self getLC:data];
    newData = [data subdataWithRange:NSMakeRange(34, datalen -2 )];
    return newData;
}

- (BOOL)isValidIns:(BYTE)ins{
    for(int i=0;i< INS_COUNT; i++){
        if(ins == INS_LIST[i]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidSW:(WORD)SW{
    for(int i=0;i< SW_COUNT; i++){
        if(SW == SW_LIST[i]){
            return YES;
        }
    }
    return NO;
}

@end
