//
//  JJCommandNetwork.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandNetwork.h"
#import "GCDAsyncUdpSocket.h"
#import "JJCommandNetworkData.h"
// #import "myReceiver.h"

@interface JJCommandNetwork() <GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong)GCDAsyncUdpSocket *network;
// @property (nonatomic,strong)myReceiver *receiver;

@end

@implementation JJCommandNetwork

+ (instancetype) getInstance{
    static JJCommandNetwork* _instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        _instance = [[JJCommandNetwork alloc] init];
    });
    return _instance;
}

- (void)setupNetwork{
    
    if (self.network == nil){
        GCDAsyncUdpSocket *network = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        self.network =  network;
        NSError *error1 = nil;
        if (![self.network bindToPort:7086 error:&error1]){
            NSLog(@"bindToPort fail");
        }
        NSError *error = nil;
        [self.network beginReceiving:&error];
    }
}

- (void)sendData:(JJCommandNetworkData *)networkData{
    NSString *host = networkData.host;
    DWORD port = networkData.port;
    NSData *data = networkData.data;
    long tag = networkData.tag;
    [self.network sendData:data toHost:host port:port withTimeout:-1 tag:tag];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotSendDataWithTag");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    NSLog(@"udpSocketDidClose");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    JJCommandNetworkData *networkPacket = [[JJCommandNetworkData alloc]init];
    NSString* host ;
    uint16_t port;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    networkPacket.host = host;
    networkPacket.port = port;
    networkPacket.data = data;
    
    // self.receiver = [myReceiver getInstance];
    // [self.receiver receiveNetworkData:networkPacket];

}

@end
