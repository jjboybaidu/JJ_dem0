//
//  JJShakeble.m
//  JJShakeble
//
//  Created by farbell-imac on 16/7/12.
//  Copyright © 2016年 farbell. All rights reserved.
//  亮屏摇一摇

#import "JJShakeble.h"
#import "JJCentralble.h"
#import <CoreMotion/CoreMotion.h>
#import <notify.h>
#import "JJFormat.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define FBBLE_SERVICE_UUID                 @[[CBUUID UUIDWithString:@"FFF0"]]
#define FBBLE_CHARACTERISTICS_LOCALUUID    @"FFF5"
#define FBBLE_CHARACTERISTICS_WRITEUUID    @"FFF6"

@interface JJShakeble()<CBPeripheralDelegate,CBCentralManagerDelegate>
@property(nonatomic,strong) NSMutableArray* blackNameArray;
@property (nonatomic, strong) dispatch_source_t scanTimer;
@property (nonatomic, strong) dispatch_source_t writeValueTimer;
@property (nonatomic, strong) dispatch_source_t disconnectTimer;

@end

@implementation JJShakeble{
    BOOL isBright;
    BOOL isFree;
    float disconnetTimeout;
    float cyclScanInterval;
    int   cyclScanCount;
    
    CMMotionManager    *motionManager;
    CBCentralManager   *myCentralManager;
    CBPeripheral       *myPeripheral;
    CBCharacteristic   *myWritableCharacteristic;
    CBCharacteristic   *myLocalIDCharacteristic;
    
}





- (NSMutableArray *)blackNameArray{
    if (_blackNameArray == nil) {
        _blackNameArray = [NSMutableArray array];
    }
    return _blackNameArray;
}
- (void)initMotionManager{
    //切换为空闲状态
    isFree = YES;
    //初始化MotionManager开启更新加速度
    [self startAccelerometerWithHandle];
}
- (void)setupMotionManager{

    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.1;

    [self initMotionManager];
    isBright = YES;
    cyclScanInterval = 0.05;
    disconnetTimeout = 10;
    cyclScanCount = disconnetTimeout/cyclScanInterval;
    
    [self registerAppforDetectBrightState];
}
-(void)registerAppforDetectBrightState {
    
    int notify_token;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&notify_token,dispatch_get_main_queue(), ^(int token) {
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        if(state == 0) {
            //切换为亮屏
            isBright = YES;
            //亮屏开启更新加速度
            [self startAccelerometerWithHandle];
            
            [self printCurrentStatues];
        
        } else {
            //切换为黑屏
            isBright = NO;
            //黑屏停止加速更新
            [motionManager stopAccelerometerUpdates];
            
            [self printCurrentStatues];
            
            //黑屏释放所有然后归位
            [self disconnectAllTask];
            
        }
        
    });
}
- (void)startAccelerometerWithHandle{
    
    [motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        double accelerameter =sqrt( pow( accelerometerData.acceleration.x , 2 ) + pow( accelerometerData.acceleration.y , 2 ) + pow( accelerometerData.acceleration.z , 2) );
        //判断是否亮屏和空闲
        BOOL isOK = isFree && isBright;
        //判断是不是空闲，是不是亮屏，是不是加速度大于
        if ( isOK && accelerameter > 2.8f) {
            //开始蓝牙连接停止加速更新
            [motionManager stopAccelerometerUpdates];
            //切换为非空闲状态
            isFree = NO;
            //使用BLE前初始化
            [self initBLE];
            [self setupCentralManager];
        }
        
        if (error)  NSLog(@"startAccelerometerWithHandle error:%@",error);
    }];
    
}
- (void)printCurrentStatues{
    if (isBright && isFree) {
        NSLog(@"亮屏 + 空闲 = isOK");
    }else{
        NSLog(@"是否亮屏%d 是否空闲%d",isBright,isFree);
    }
    
}











//初始化BLE
- (void)initBLE{
    
    if (myCentralManager) {
        if ([myCentralManager isScanning]) [myCentralManager stopScan];
        
        if (myPeripheral) {
            [myCentralManager cancelPeripheralConnection:myPeripheral];
            myPeripheral = nil;
        }
        
        if (myWritableCharacteristic) myWritableCharacteristic = nil;
        
        if (myLocalIDCharacteristic) myLocalIDCharacteristic = nil;
    }
}
- (void)setupCentralManager{
    
    NSLog(@"________________________________________________________开始");
    
    [self setupDisconnectTimerInSecond:disconnetTimeout];
    
    if(myCentralManager == nil){
        myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(0, 0) options:nil];
    }else{
        [self setupcycleScanWithStartTimeSinceNow:0.01 interval:cyclScanInterval repeatcount:cyclScanCount];
    }
}
#define mark - disconnectTimer
- (void)setupDisconnectTimerInSecond:(float)second{
    //初始化前先取消之前的DisconnectTimer
    [self cancelDisconnectTimer];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.disconnectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTimer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.disconnectTimer, startTimer, interval, 0);
    
    dispatch_source_set_event_handler(self.disconnectTimer, ^{
        //延时释放所有
        [self disconnectAllTask];
        
    });
    
    dispatch_resume(self.disconnectTimer);
}
#define mark - scanTimer
- (void)setupcycleScanWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{
    //初始化前先取消之前的ScanTimer
    [self cancelScanTimer];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.scanTimer, ^{
        // 执行事件
        if ([myCentralManager isScanning]) [myCentralManager stopScan];
        [myCentralManager scanForPeripheralsWithServices:FBBLE_SERVICE_UUID options:nil];
        NSLog(@"进入扫描Timer");
        
        count++;
        if (count == repeatcount) {
            //扫描repeatcount后取消之前的ScanTimer
            [self cancelScanTimer];
            //扫描repeatcount后取消之前所有的任务
            NSLog(@"我都扫了%d次了",repeatcount);
            [self disconnectAllTask];
        }
        
    });
    
    dispatch_resume(self.scanTimer);
}
#define mark - writeValueTimer
- (void)setupWriteValueWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{
    //初始化前先取消之前的WriteValueTimer
    [self cancelWriteValueTimer];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.writeValueTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.writeValueTimer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.writeValueTimer, ^{
        
        if (myPeripheral && myWritableCharacteristic) {
            
            [myPeripheral writeValue:[self setupUnlockCommand] forCharacteristic:myWritableCharacteristic type:1];
            NSLog(@"进入发命令Timer");
        }
        
        count++;
        if (count == repeatcount) {
            if (myPeripheral && myWritableCharacteristic) {
                [myPeripheral writeValue:[self setupDisconnectCommand] forCharacteristic:myWritableCharacteristic type:1];
                NSLog(@"重发3次仍然失败——发送断开命令");
            }
            //重发repeatcount后取消之前的WriteValueTimer
            [self cancelWriteValueTimer];
            //重发失败释放所有
            [self disconnectAllTask];
            
        }
        
    });
    
    dispatch_resume(self.writeValueTimer);
}
- (NSData*)setupDisconnectCommand{
    NSMutableData* mutableData = [NSMutableData data];
    unsigned char cla = 0x00;
    [mutableData appendBytes:&cla length:1];
    unsigned char ins = 0xA0;
    [mutableData appendBytes:&ins length:1];
    unsigned char p1 = 0x00;
    [mutableData appendBytes:&p1 length:1];
    unsigned char p2 = 0x00;
    [mutableData appendBytes:&p2 length:1];
    unsigned char p3 = 0x00;
    [mutableData appendBytes:&p3 length:1];
    return mutableData;
}
- (NSData*)setupUnlockCommand{
    NSMutableData* mutableData = [NSMutableData data];
    unsigned char cla = 0x00;
    [mutableData appendBytes:&cla length:1];
    unsigned char ins = 0x81;
    [mutableData appendBytes:&ins length:1];
    unsigned char p1 = 0x00;
    [mutableData appendBytes:&p1 length:1];
    unsigned char p2 = 0x00;
    [mutableData appendBytes:&p2 length:1];
    unsigned char p3 = 0x00;
    [mutableData appendBytes:&p3 length:1];
    return mutableData;
}
#define mark - cancelTimer
- (void)cancelScanTimer{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
        self.scanTimer = nil;
        NSLog(@"_停止扫描Timer");
    }else{
        return;
    }
}
- (void)cancelWriteValueTimer{
    if (self.writeValueTimer) {
        dispatch_cancel(self.writeValueTimer);
        self.writeValueTimer = nil;
        NSLog(@"_停止发命令Timer");
    }else{
        return;
    }
}
- (void)cancelDisconnectTimer{
    if (self.disconnectTimer ) {
        dispatch_cancel(self.disconnectTimer);
        self.disconnectTimer = nil;
        NSLog(@"________________________________________________________结束");
    }else{
        return;
    }
}
- (void)cancelAllTimer{
    [self cancelScanTimer];
    [self cancelWriteValueTimer];
    [self cancelDisconnectTimer];
}
- (void)disconnectAllTask{
    if (myCentralManager) {
        //断开连接取消所有Timer
        [self cancelAllTimer];
        //断开连接初始化MotionManager
        [self initMotionManager];
        //断开连接初始化BLE
        [self initBLE];
    }else{
        return;
    }
}











- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (myCentralManager.state == CBCentralManagerStatePoweredOn){
        
        [self setupcycleScanWithStartTimeSinceNow:0.01 interval:cyclScanInterval repeatcount:cyclScanCount];
    }else if (myCentralManager.state == CBCentralManagerStatePoweredOff) {
        //关闭蓝牙释放所有
        [self disconnectAllTask];
    }else{
        return;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    [self cancelScanTimer];
    
    if ([peripheral.name isEqualToString:@"TrudBleAcces"]) {
        if (self.blackNameArray.count == 0 ){
            [myCentralManager stopScan];
            myPeripheral = peripheral;
            [myCentralManager connectPeripheral:peripheral options:nil];
        }else{
            for (NSString *string in self.blackNameArray) {
                if (![peripheral.identifier.UUIDString isEqualToString: string]) {
                    [myCentralManager stopScan];
                    myPeripheral = peripheral;
                    [myCentralManager connectPeripheral:peripheral options:nil];
                }
            }
        }
    }else{
        return;
    }
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"____成功连接");
    peripheral.delegate = self;
    [peripheral discoverServices:FBBLE_SERVICE_UUID];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    
    NSLog(@"____成功发现服务");
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID],[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]] forService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    
    NSLog(@"____成功发现服务特征");
    for (CBCharacteristic *characteristic in service.characteristics){
        
        [peripheral readValueForCharacteristic:characteristic];
        
        if ( [characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID] ] ){
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            myWritableCharacteristic = characteristic;
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]]){
            myLocalIDCharacteristic = characteristic;
        }
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if ( [characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID] ] ){
        
        NSString *string = [JJFormat formatToHexadecimalStringWithNSData:characteristic.value];
        
        if (string != nil && ![string isEqual: @"9000"]) {
            
            [self setupWriteValueWithStartTimeSinceNow:0 interval:0.8 repeatcount:3];
            
        }else if([string isEqual: @"9000"]){
            
            NSLog(@"_开门成功");
            //蓝牙开门成功释放所有
            [self disconnectAllTask];
            
        }
    }
}

@end
