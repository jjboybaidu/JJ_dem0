//
//  JJCommandTask.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandTask.h"
#import "JJCommandNetworkData.h"
#import "JJCommandX.h"

@implementation JJCommandTask

- (instancetype) initWithNetworkPacket:(JJCommandNetworkData*)networkPacket
                                  dely:(int)dely
                            maxSendNum:(int)maxSendNum
                              taskName:(NSString*)taskName
                         isSuccessSend:(BOOL)isSuccessSend{
    if(self = [super init]){
        self.isSuccessSend = isSuccessSend;
        self.taskName = taskName;
        self.dely = dely;
        self.maxSendNum = maxSendNum;
        self.networkPacket = networkPacket;
    }
    return self;
}

- (instancetype)initWithReceiverTaskData:(NSData *)data SuccessHandle:(BOOL)iSSuccessHandle{
    if (self == [super init]) {
        self.iSSuccessHandle = iSSuccessHandle;
        self.data = data;
    }
    return self;
}

/*
 * 任务对外接口(PPnetworkPacket)
 */
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
                                       port:(DWORD)port{
    
    // commandData include defineData
    NSData *data = [[JJCommandX getInstance]creatRequestCommandWithCLA:0x00
                                                                  Ins:InsValue
                                                                   P1:p1Value
                                                                   P2:p2Value
                                                                   SN:snValue
                                                             SourceID:sourceIDValue
                                                             TargetID:targetIDValue
                                                                Falg1:0x00
                                                                Falg2:0x00
                                                           defineData:defineDataValue];
    JJCommandNetworkData *networkPacket = [[JJCommandNetworkData alloc]init];
    networkPacket.data = data;
    networkPacket.host = host;
    networkPacket.port = port;
    float dely = delyValue;
    int maxSendNum = maxSendNumValue;
    BOOL isSuccessSend = 0;
    NSString *taskName = [NSString stringWithFormat:@"%hhu",InsValue];
    
    return [self initWithNetworkPacket:networkPacket dely:dely maxSendNum:maxSendNum taskName:taskName isSuccessSend:isSuccessSend];
}


@end
