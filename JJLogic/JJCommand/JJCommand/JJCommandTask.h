//
//  JJCommandTask.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommandParam.h"

@class JJCommandNetworkData;

@interface JJCommandTask : NSObject

@property(atomic,assign) BOOL isSuccessSend;
@property(nonatomic,assign) int dely;
@property(nonatomic,assign) int maxSendNum;
@property(nonatomic,strong) NSData * data;
@property(nonatomic,copy) NSString * taskName;
@property(nonatomic,copy) NSString * host;
@property(nonatomic,strong) JJCommandNetworkData *networkPacket;
@property(atomic,assign) BOOL iSSuccessHandle;

- (instancetype)initWithReceiverTaskData:(NSData *)data SuccessHandle:(BOOL)iSSuccessHandle;

- (instancetype)setCommandTaskWithPacketIns:(BYTE)InsValue
                                         p1:(BYTE)p1Value
                                         p2:(BYTE)p2Value
                                         sn:(WORD)snValue
                                   sourceID:(DWORD)sourceIDValue
                                   targetID:(DWORD)targetIDValue
                                 defineData:(NSData *)defineDataValue
                                       dely:(float)delyValue
                                 maxSendNum:(int)maxSendNumValue
                                       host:(NSString *)host
                                       port:(DWORD)port;

@end
