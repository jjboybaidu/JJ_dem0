//
//  JJCommandSender.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommandParam.h"

@interface JJCommandSender : NSObject
+ (instancetype) getInstance;
- (void)setupSender;
- (void)setCommonSendTaskWithPacketIns:(BYTE)InsValue
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
