//
//  JJCommandX.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommandParam.h"

@interface JJCommandX : NSObject

+ (instancetype) getInstance;
- (BOOL)IScommand:(NSData*)data;
- (BOOL)IsRequestCommand:(NSData *)data;
- (BOOL)IsResponseCommand:(NSData *)data;
- (BOOL)IsSuccessResponseCode:(NSData *)data;
- (WORD)getHearder:(NSData*)data;
- (BYTE)getCLA:(NSData*)data;
- (BYTE)getINS:(NSData*)data;
- (BYTE)getP1:(NSData*)data;
- (BYTE)getP2:(NSData*)data;
- (WORD)getSN:(NSData*)data;
- (DWORD64)getSourceID:(NSData*)data;
- (DWORD64)getTargetID:(NSData*)data;
- (DWORD)getFLAG1:(NSData*)data;
- (WORD)getFLAG2:(NSData*)data;
- (WORD)getLC:(NSData*)data;
- (NSData*)getData:(NSData*)data;
- (WORD)getCRC:(NSData*)data;
- (WORD)getTailer:(NSData*)data;
- (WORD)getResposeCode:(NSData*)data;
- (BOOL)isValidIns:(BYTE)ins;
- (BOOL)isValidSW:(WORD)SW;
- (BYTE)CalcCRC8:(BYTE *)pData iLength:(int)iLength;
- (NSData*)getDataWithoutResposeCode:(NSData*)data;

- (NSData *)creatRequestCommandWithCLA:(BYTE)CLAValue
                                   Ins:(BYTE)insValue
                                    P1:(BYTE)p1Value
                                    P2:(BYTE)p2Value
                                    SN:(WORD)snValue
                              SourceID:(DWORD64)sourceIDValue
                              TargetID:(DWORD64)targetIDValue
                                 Falg1:(DWORD)falg1Value
                                 Falg2:(WORD)falg2Value
                            defineData:(NSData *)defineData;

@end
