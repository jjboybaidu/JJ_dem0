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

#define currenThread NSLog(@"%s currentThread%@",__func__,[NSThread currentThread]);

@interface JJShakeble()<CBPeripheralDelegate,CBCentralManagerDelegate>
@property(nonatomic,strong) CMMotionManager *motionManager;
@property(nonatomic,strong) NSMutableArray *mutArray;
@property(nonatomic,strong) NSMutableArray* blackNameArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_source_t disconnectTimer;
@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, strong) NSTimer *printTimer;

@end

@implementation JJShakeble{
    BOOL isBright;
    BOOL isSending;
    BOOL isDiscoverPeripheral;
    BOOL isConnectPeripheral;
    BOOL isDiscoverServices;
    BOOL isDiscoverCharacteristics;
    
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
- (NSMutableArray *)mutArray{
    if (_mutArray == nil) {
        _mutArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _mutArray;
}

- (void)setupMotionManager{

    self.motionManager = [[CMMotionManager alloc] init];
    
    //加速仪更新频率，以秒为单位
    self.motionManager.accelerometerUpdateInterval = 0.01;
    isBright = YES;
    isSending = NO;

    [self startAccelerometerWithHandle];

    [self registerAppforDetectBrightState];
    
    [self cyclePrint];
}
- (void)cyclePrint{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.printTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(printScanStatues) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.printTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop]run];
    });
}
- (void)printScanStatues{
    if (myCentralManager.isScanning) {
        [myCentralManager stopScan];
        NSLog(@"正在扫描");
    }else{
        NSLog(@"停止扫描");;
    }
}
-(void)registerAppforDetectBrightState {
    
    int notify_token;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&notify_token,dispatch_get_main_queue(), ^(int token) {
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        if(state == 0) {
            isBright = YES;
        } else {
            isBright = NO;
            [myCentralManager stopScan];
        }
        
    });
}
- (void)startAccelerometerWithHandle{
    
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        double accelerameter =sqrt( pow( accelerometerData.acceleration.x , 2 ) + pow( accelerometerData.acceleration.y , 2 ) + pow( accelerometerData.acceleration.z , 2) );
        if (!isSending && isBright && accelerameter > 1.6f) {
            isSending = YES;
            [self setupCentralManager];
        }
        
        if (error)  NSLog(@"startAccelerometerWithHandle error:%@",error);
    }];
    
}




- (void)setupCentralManager{
    
    NSLog(@"开始____________开始______________开始_____________________开始________________开始________开始");
    
    isDiscoverPeripheral = NO;
    isConnectPeripheral = NO;
    isDiscoverServices = NO;
    isDiscoverCharacteristics = NO;
    
    [self setupDisconnectTimerInSecond:5];
    if(myCentralManager == nil){
        myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(0, 0) options:nil];
    }else{
        [self cycleScan];
    }
}
- (void)setupDisconnectTimerInSecond:(float)second{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.disconnectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.disconnectTimer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.disconnectTimer, ^{
        
        [self disconnectPeripheral];
        
    });
    
    dispatch_resume(self.disconnectTimer);
    
}
- (void)disconnectPeripheral{
    if (myCentralManager) {
        
        if (self.scanTimer) {
            [self.scanTimer invalidate];
            self.scanTimer = nil;
            NSLog(@"扫描计时器停止————————————————");
        }
        
       if ([myCentralManager isScanning]) [myCentralManager stopScan];
        
        if (self.timer ) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
        if (self.disconnectTimer ) {
            dispatch_cancel(self.disconnectTimer);
            self.disconnectTimer = nil;
        }
        
        if (myPeripheral) {
            [myCentralManager cancelPeripheralConnection:myPeripheral];
            myPeripheral = nil;
        }
        
        isSending = NO;
        
    }else{
        return;
    }
}




- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (myCentralManager.state == CBCentralManagerStatePoweredOn){
        [self cycleScan];
    }else if (myCentralManager.state == CBCentralManagerStatePoweredOff) {
        if ([myCentralManager isScanning]) [myCentralManager stopScan];
    }else{
        return;
    }
}
- (void)cycleScan{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.scanTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(scan) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.scanTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop]run];
    });
}
- (void)scan{
    NSDictionary* scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [myCentralManager scanForPeripheralsWithServices:FBBLE_SERVICE_UUID options:scanOptions];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    isDiscoverPeripheral = YES;
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
       if ([myCentralManager isScanning]) [myCentralManager stopScan];
        [self cycleScan];
        
    }
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    isConnectPeripheral = YES;
    NSLog(@"____didConnectPeripheral Peripheral connected");
    peripheral.delegate = self;
    [peripheral discoverServices:FBBLE_SERVICE_UUID];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    isDiscoverServices = YES;
    NSLog(@"____didDiscoverServices Discovered service ");
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID],[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]] forService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    isDiscoverCharacteristics = YES;
    NSLog(@"____didDiscoverCharacteristicsForService Discovered characteristic");
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
            
            if ([myCentralManager isScanning])  [myCentralManager stopScan];
            [self disconnectPeripheral];
            NSLog(@"棒棒哒！！");
        }
    }
}



- (void)setupWriteValueWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.timer, ^{

        if (myPeripheral && myWritableCharacteristic) {

            [myPeripheral writeValue:[self setupUnlockCommand] forCharacteristic:myWritableCharacteristic type:1];
            NSLog(@"已发送开锁命令");
        }
        
        count++;
        if (count == repeatcount) {
            if (myPeripheral && myWritableCharacteristic) {
                
                [myPeripheral writeValue:[self setupDisconnectCommand] forCharacteristic:myWritableCharacteristic type:1];
                NSLog(@"重发3次仍然失败——发送断开命令");
                [self disconnectPeripheral];
            }
            if (self.timer) {
                dispatch_cancel(self.timer);
                self.timer = nil;
            }else{
                return;
            }
            
        }
        
    });
    
    dispatch_resume(self.timer);
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


@end
