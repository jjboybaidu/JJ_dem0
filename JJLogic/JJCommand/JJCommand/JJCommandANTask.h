//
//  JJCommandANTask.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommandParam.h"

@interface JJCommandANTask : NSObject
- (void)sendANWithSourceID:(DWORD)sourceID targetID:(DWORD)targetID dely:(float)dely maxSendNum:(int)maxSendNum host:(NSString *)host port:(uint16_t)port;
- (void)setupCommandAN;
+ (instancetype) getInstance;
@property (nonatomic,strong)NSArray *array;



#if 0
- (void)initWithAccessNum;

- (void)sendAccessNumWithp1:(BYTE)p1Value
                         p2:(BYTE)p2Value
                         sn:(WORD)snValue
                   sourceID:(DWORD)sourceIDValue
                   targetID:(DWORD)targetIDValue
                       dely:(float)delyValue
                 maxSendNum:(int)maxSendNumValue
                       host:(NSString *)host
                       port:(uint16_t)port
                      array:(NSArray *)array;

// 输出为LocalID格式
- (NSData *)dataLocalID:(NSString *)idString;
#endif

@end

