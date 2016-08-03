//
//  JJCommandSender.m
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJCommandSender.h"
#import "TransitionKit.h"
#import "JJCommandReceiver.h"
#import "JJCommandNetwork.h"
#import "JJCommandNetworkData.h"
#import "JJCommandNotification.h"
#import "JJCommandX.h"
#import "JJCommandTask.h"

@interface JJCommandSender()
@property (nonatomic,strong)TKStateMachine *inboxStateMachine;
@property (nonatomic,strong)NSMutableArray *taskTable;
@property (nonatomic,strong)JJCommandNetwork *network;

@end

@implementation JJCommandSender

- (NSMutableArray *)taskTable{
    if (_taskTable == nil) {
        _taskTable = [NSMutableArray arrayWithCapacity:5];
    }
    return _taskTable;
}

+ (instancetype) getInstance{
    static JJCommandSender* _instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        _instance = [[JJCommandSender alloc] init];
    });
    return _instance;
}

- (void)setupSender{
    
    self.network = [JJCommandNetwork getInstance];
    [self.network setupNetwork];
    
    [self mainSenderStatue];
    [self mainSender];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enumTaskTableforReceiver:) name:NOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failResponseCodeDealWith) name:NOTIFICATION_FAIL object:nil];
}

- (void)enumTaskTableforReceiver:(NSNotification *)notification{
    NSData *objData = [notification object];
    BYTE objINS = [[JJCommandX getInstance] getINS:objData];
    NSEnumerator *enumerator = [self.taskTable reverseObjectEnumerator];
    for (JJCommandTask *task  in enumerator) {
        BYTE INS = [[JJCommandX getInstance]getINS:task.networkPacket.data];
        if (objINS == INS && !task.isSuccessSend) {
            NSLog(@"成功的任务是：%@",task.taskName);
            task.isSuccessSend = 1;
            //            [self.inboxStateMachine fireEvent:@"freeEvent" userInfo:nil error:nil];
            if (objINS == INS_UNLOCK) {
                
            }
        }else{
            NSLog(@"任务已经成功或者重发失败");
        }
    }
}

- (void)failResponseCodeDealWith{
    NSLog(@"你执行的任务没有成功");
}

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
                                  port:(DWORD)port{
    
    if ([self.inboxStateMachine.currentState.name isEqual:@"free"]) {
        JJCommandTask *task = [[JJCommandTask alloc]init];
        task =  [task setCommandTaskWithPacketIns:InsValue
                                               p1:p1Value
                                               p2:p2Value
                                               sn:snValue
                                         sourceID:sourceIDValue
                                         targetID:targetIDValue
                                       defineData:defineDataValue
                                             dely:delyValue
                                       maxSendNum:maxSendNumValue
                                             host:(NSString *)host
                                             port:(DWORD)port];
        @synchronized (self) {
            NSString *hostRegex = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", hostRegex];
            if (host && port && [predicate evaluateWithObject:host]) {
                [self.taskTable addObject:task];
            }else{
                NSLog(@"没有IP或PORT或格式不正确");
            }
        }
    }else{
        NSLog(@"用户忙请稍后");
    }
}

- (void)mainSender{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
        NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:futureDate
                                                    interval:0.05
                                                      target:self
                                                    selector:@selector(enumTaskTable)
                                                    userInfo:nil
                                                     repeats:YES];
        [myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
        [myRunLoop run];
        
    });
}

// 遍历任务列表，发送未成功数据
- (void)enumTaskTable{
    NSEnumerator *enumerator = [self.taskTable reverseObjectEnumerator];
    for (JJCommandTask *task  in enumerator) {
        @autoreleasepool {
            if (!task.isSuccessSend) {
                [self.inboxStateMachine fireEvent:@"busyEvent" userInfo:nil error:nil];
                @synchronized (self) {
                    for (int i = 0; i < task.maxSendNum +1; i ++) {
                        if (task.isSuccessSend) {
                            [self.inboxStateMachine fireEvent:@"freeEvent" userInfo:nil error:nil];
                            break;
                        }
                        
                        if (i == task.maxSendNum) {
                            @synchronized (self) {
                                task.isSuccessSend = 1;
                            }
                            [self.inboxStateMachine fireEvent:@"freeEvent" userInfo:nil error:nil];
                            break;
                        }
                        // 发送任务的数据
                        [self.network sendData:task.networkPacket];
                        [NSThread sleepForTimeInterval:task.dely];
                    }
                    [self.inboxStateMachine fireEvent:@"freeEvent" userInfo:nil error:nil];
                }
            }
        }
    }
    [self cleanTaskTable];
}

- (void)cleanTaskTable{
    @synchronized (self) {
        NSEnumerator *enumerator = [self.taskTable reverseObjectEnumerator];
        for (JJCommandTask *task  in enumerator) {
            if (task.isSuccessSend) {
                [self.taskTable removeObject:task];
            }
        }
    }
}

- (void)mainSenderStatue{
    TKStateMachine *inboxStateMachine = [TKStateMachine new];
    self.inboxStateMachine = inboxStateMachine;
    TKState *free = [TKState stateWithName:@"free"];
    [free setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    TKState *busy = [TKState stateWithName:@"busy"];
    [busy setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        
    }];
    [inboxStateMachine addStates:@[ free, busy]];
    inboxStateMachine.initialState = free;
    TKEvent *busyEvent = [TKEvent eventWithName:@"busyEvent" transitioningFromStates:@[ free ] toState:busy];
    TKEvent *freeEvent = [TKEvent eventWithName:@"freeEvent" transitioningFromStates:@[ busy] toState:free];
    [inboxStateMachine addEvents:@[ busyEvent, freeEvent]];
    [inboxStateMachine activate];
    [inboxStateMachine isInState:@"free"];
}

- (void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}

@end
