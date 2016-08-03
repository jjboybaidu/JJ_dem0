//
//  JJCommandReceiver.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJCommandNetworkData;

@interface JJCommandReceiver : NSObject

//@property(nonatomic,weak)id<myReceiverDelegate>delegate;

+ (instancetype)getInstance;
- (void)receiveNetworkData:(JJCommandNetworkData *)networkData;

// 初始化
//- (void)initWithReceiver;

// 接收数据
//- (void)receiveDataUsingNetworkPacket:(myNetworkData *)networkPacket;

@end
