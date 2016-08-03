//
//  JJCommandReceiver.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandReceiver.h"
#import "JJCommandNotification.h"
#import "TransitionKit.h"
#import "JJCommandNetwork.h"
#import "JJCommandNetworkData.h"
#import "JJCommandX.h"
#import "JJCommandTask.h"


@interface JJCommandReceiver()<JJCommandNetworkDelegate>
@property (nonatomic,strong)TKStateMachine *inboxStateMachine;
@property (nonatomic,strong)NSMutableArray *receiverDataTable;
@property (nonatomic,strong)JJCommandNetworkData *networkData;
@property (nonatomic,strong)JJCommandNetwork *network;

@end

@implementation JJCommandReceiver

+ (instancetype) getInstance{
    static JJCommandReceiver* _instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        _instance = [[JJCommandReceiver alloc] init];
    });
    return _instance;
}

- (NSMutableArray *)receiverDataTable{
    if (_receiverDataTable == nil) {
        _receiverDataTable = [NSMutableArray arrayWithCapacity:10];
    }
    return _receiverDataTable;
}

- (void)receiveNetworkData:(JJCommandNetworkData *)networkData{
    [self mainReceiverStatue];
    if (![[JJCommandX getInstance] IScommand:networkData.data]) return ;
    @synchronized (self) {
        // 判断接收的是不是请求命令
        if ([[JJCommandX getInstance] IsRequestCommand:networkData.data]) {
            JJCommandTask *task = [[JJCommandTask alloc]init];
            task =  [task initWithReceiverTaskData:networkData.data SuccessHandle:NO];
            if ([self.inboxStateMachine.currentState.name isEqual:@"freeR"]) {
                [self.receiverDataTable addObject:task];
                [self enumReceiverDataTable];
            }
        }else{
            // 判断接收的响应码是不是成功的
            if ([[JJCommandX getInstance] IsSuccessResponseCode:networkData.data]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUCCESS object:networkData.data];
                //                if (SN == 2000) {
                //                    [NSThread sleepForTimeInterval:2];
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_START_SENDING_AN object:networkData.data];
                //                }
                //
                //                if (SN == 2001) {
                //                    [NSThread sleepForTimeInterval:2];
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_START_END_SENDING_AN object:networkData.data];
                //                }
            }else if (![[JJCommandX getInstance] IsSuccessResponseCode:networkData.data]){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAIL object:networkData.data];
            }
        }
    }
}

- (void)enumReceiverDataTable{
    for (JJCommandTask *task  in self.receiverDataTable) {
        @synchronized (self) {
            if (!task.iSSuccessHandle) {
                [self.inboxStateMachine fireEvent:@"busyEventR" userInfo:nil error:nil];
                @autoreleasepool {
                    BYTE INS = [[JJCommandX getInstance] getINS:task.data];
                    if (INS == 0x01) {
                        NSLog(@"INS = %d",INS);
                        task.iSSuccessHandle = 1;
                    }else{
                        task.iSSuccessHandle = 1;
                        [self.inboxStateMachine fireEvent:@"freeEventR" userInfo:nil error:nil];
                    }
                }
            }
        }
    }
    [self cleanReceiverDataTable];
}

- (void)cleanReceiverDataTable{
    @synchronized (self) {
        for (JJCommandTask *task   in self.receiverDataTable) {
            if (task.iSSuccessHandle) {
                [self.receiverDataTable removeObject:task];
            }
        }
    }
}

- (void)mainReceiverStatue{
    TKStateMachine *inboxStateMachine = [TKStateMachine new];
    self.inboxStateMachine = inboxStateMachine;
    TKState *freeR = [TKState stateWithName:@"freeR"];
    [freeR setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    TKState *busyR = [TKState stateWithName:@"busyR"];
    [busyR setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    [inboxStateMachine addStates:@[ freeR, busyR]];
    inboxStateMachine.initialState = freeR;
    TKEvent *busyEventR = [TKEvent eventWithName:@"busyEventR" transitioningFromStates:@[ freeR ] toState:busyR];
    TKEvent *freeEventR = [TKEvent eventWithName:@"freeEventR" transitioningFromStates:@[ busyR] toState:freeR];
    [inboxStateMachine addEvents:@[ busyEventR, freeEventR ]];
    [inboxStateMachine activate];
    [inboxStateMachine isInState:@"freeR"];
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}





























#if 0
// 创建单例接收者
+ (instancetype) getInstance{
    static myReceiver* Instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        Instance = [[myReceiver alloc] init];
    });
    return Instance;
}

// 初始化接收者


- (void)receiveDataUsingNetworkPacket:(myNetworkData *)networkPacket{
    NSLog(@"%@",networkPacket.data);
    BOOL dele = [self.delegate respondsToSelector:@selector(handleNetworkData:)];
    //    NSLog(@"%@",self.delegate);
    //    NSLog(@"dele %d",dele);
    if (dele) {
        [self.delegate handleNetworkData:networkPacket];
    }
}


// 接收网络数据
- (void)receiveDataUsingNetworkPacket:(myNetworkData *)networkPacket{
    self.networkData = networkPacket;
    [self setupNetwork:self.networkData];
    // 接收到的UDP数据
    NSData *data = networkPacket.data;
    // 打印接收的数据
    //    NSLog(@"收到门口机数据： %@",[[myCommand getInstance]getData:data]);
    
    @synchronized (self) {
        // 判断接收的是不是请求命令
        if ([[myCommand getInstance] IsRequestCommand:data]) {
            myTask *task = [[myTask alloc]init];
            task =  [task initWithReceiverTaskData:data SuccessHandle:NO];
            
            if ([self.inboxStateMachine.currentState.name isEqual:@"freeR"]) {
                [self.receiverDataTable addObject:task];
                [self enumReceiverDataTable];
            }
        }else{
            // 判断接收的响应码是不是成功的
            if ([[myCommand getInstance] IsSuccessResponseCode:data]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUCCESS object:data];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STARTSENDINGAN object:data];
            }else if (![[myCommand getInstance] IsSuccessResponseCode:data]){
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAIL object:data];
            }
        }
    }
}


// 遍历接收数据数组
- (void)enumReceiverDataTable{
    for (myTask *task  in self.receiverDataTable) {
        @synchronized (self) {
            
            if (!task.iSSuccessHandle) {
                NSLog(@"%@",self.receiverDataTable);
                [self.inboxStateMachine fireEvent:@"busyEventR" userInfo:nil error:nil];
                @autoreleasepool {
                    BYTE INS = [[myCommand getInstance] getINS:task.data];
                    
                    if (INS == 0x01) {
                        task.iSSuccessHandle = 1;
                        NSLog(@"心跳");
                    }else{
                        NSLog(@"APP消息推送");
                        
                        task.iSSuccessHandle = 1;
                        [self.inboxStateMachine fireEvent:@"freeEventR" userInfo:nil error:nil];
                    }
                    
                }
            }
            
        }
    }
    
    [self cleanReceiverDataTable];
}

// 清除数据
- (void)cleanReceiverDataTable{
    @synchronized (self) {
        for (myTask *task   in self.receiverDataTable) {
            if (task.iSSuccessHandle) {
                [self.receiverDataTable removeObject:task];
            }
        }
    }
}

// 接收数据状态机
- (void)mainReceiverStatue{
    TKStateMachine *inboxStateMachine = [TKStateMachine new];
    self.inboxStateMachine = inboxStateMachine;
    
    TKState *freeR = [TKState stateWithName:@"freeR"];
    [freeR setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    
    TKState *busyR = [TKState stateWithName:@"busyR"];
    [busyR setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    
    [inboxStateMachine addStates:@[ freeR, busyR]];
    
    inboxStateMachine.initialState = freeR;
    
    TKEvent *busyEventR = [TKEvent eventWithName:@"busyEventR" transitioningFromStates:@[ freeR ] toState:busyR];
    
    TKEvent *freeEventR = [TKEvent eventWithName:@"freeEventR" transitioningFromStates:@[ busyR] toState:freeR];
    
    [inboxStateMachine addEvents:@[ busyEventR, freeEventR ]];
    
    [inboxStateMachine activate];
    [inboxStateMachine isInState:@"freeR"];
}

- (void)setupNetwork{
    self.network = [myNetwork getInstance];
    self.network.delegate = self;
}

- (void)handleNetworkData:(myNetworkData *)networkData{
    [self.receiverDataTable addObject:networkData];
}

- (void)mainReceiver{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
        NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                                                    interval:0.1
                                                      target:self
                                                    selector:@selector(enumReceiverDataTable)
                                                    userInfo:nil
                                                     repeats:YES];
        [myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
        [myRunLoop run];
    });
}

- (void)enumReceiverDataTable{
    for (myNetworkData *networkData in self.receiverDataTable) {
        NSData *data = networkData.data;
        @synchronized (self) {
            // 判断接收的是不是请求命令
            if ([[myCommand getInstance] IsRequestCommand:data]) {
                myTask *task = [[myTask alloc]init];
                task =  [task initWithReceiverTaskData:data SuccessHandle:NO];
                
                if ([self.inboxStateMachine.currentState.name isEqual:@"freeR"]) {
                    [self.receiverDataTable addObject:task];
                    [self enumReceiverDataTable];
                }
            }else{
                // 判断接收的响应码是不是成功的
                if ([[myCommand getInstance] IsSuccessResponseCode:data]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUCCESS object:data];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STARTSENDINGAN object:data];
                }else if (![[myCommand getInstance] IsSuccessResponseCode:data]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAIL object:data];
                }
            }
        }
    }
}
#endif


@end
