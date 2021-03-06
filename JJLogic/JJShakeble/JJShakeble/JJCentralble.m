//
//  JJCentralble.m
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import "JJCentralble.h"
#import "JJFormat.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define currenThread NSLog(@"%s currentThread%@",__func__,[NSThread currentThread]);
#define FBBLE_PERIPHERALS_NAME             @"TrudBleAcces"
#define FBBLE_UNLOCK_SUCCESS               @"36864"
#define FBBLE_SERVICE_UUID                 @[[CBUUID UUIDWithString:@"FFF0"]]
#define FBBLE_CHARACTERISTICS_LOCALUUID    @"FFF5"
#define FBBLE_CHARACTERISTICS_WRITEUUID    @"FFF6"

@interface JJCentralble()<CBPeripheralDelegate,CBCentralManagerDelegate>
@property(nonatomic,strong)NSMutableArray* blackNameArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_source_t disconnectTimer;

@end

@implementation JJCentralble{
    CBCentralManager   *myCentralManager;
    CBPeripheral       *myPeripheral;
    CBCharacteristic   *myWritableCharacteristic;
    CBCharacteristic   *myLocalIDCharacteristic;
    BOOL isDiscoverPeripheral;
    BOOL isConnectPeripheral;
    BOOL isDiscoverServices;
    BOOL isDiscoverCharacteristics;
}

- (NSMutableArray *)blackNameArray{
    if (_blackNameArray == nil) {
        _blackNameArray = [NSMutableArray array];
    }
    return _blackNameArray;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)setupCentral{
    NSLog(@"开始____________开始______________开始_____________________开始________________开始________开始");
    isDiscoverPeripheral = NO;
    isConnectPeripheral = NO;
    isDiscoverServices = NO;
    isDiscoverCharacteristics = NO;
    // 设置延时2.8秒后断开设备
    [self setupSonThreadDelayInSecond:3];
    if(myCentralManager == nil){
        myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(0, 0) options:nil];
    }else{
        [myCentralManager stopScan];
        [myCentralManager scanForPeripheralsWithServices:FBBLE_SERVICE_UUID options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    }
    
}

- (void)disconnectPeripheral{
    if (myCentralManager && myPeripheral) {
        if (self.timer ) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
        [myCentralManager stopScan];
        [myCentralManager cancelPeripheralConnection:myPeripheral];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"centralble" object:nil];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"centralble" object:nil];
        return;
    }
}

- (void)removePeripheral{
    if (myCentralManager && myPeripheral) {
        if (self.timer ) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
        [myCentralManager stopScan];
        [myCentralManager cancelPeripheralConnection:myPeripheral];
       
    }else{
        
        return;
    }
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn){
        [myCentralManager scanForPeripheralsWithServices:FBBLE_SERVICE_UUID options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    }else if (central.state == CBCentralManagerStatePoweredOff) {
        [myCentralManager stopScan];
    }else{
        return;
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    isDiscoverPeripheral = YES;
    // NSLog(@"centralManager __________________%@",myCentralManager);
    if ([peripheral.name isEqualToString:FBBLE_PERIPHERALS_NAME]) {
        if (self.blackNameArray.count == 0 ){
            [myCentralManager stopScan];
            NSLog(@"didDiscoverPeripheral____DidDiscoverPeripheral scanning stopped");
            myPeripheral = peripheral;
            [myCentralManager connectPeripheral:peripheral options:nil];
        }else{
            for (NSString *string in self.blackNameArray) {
                if (![peripheral.identifier.UUIDString isEqualToString: string]) {
                    [myCentralManager stopScan];
                    myPeripheral = peripheral;
                    [myCentralManager connectPeripheral:peripheral options:nil];
                    NSLog(@"didDiscoverPeripheral____DidDiscoverPeripheral scanning stopped");
                }
            }
        }
    }else{
        [myCentralManager stopScan];
        [myCentralManager scanForPeripheralsWithServices:FBBLE_SERVICE_UUID options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
        
    }
    
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    isConnectPeripheral = YES;
    NSLog(@"didConnectPeripheral____Peripheral connected");
    peripheral.delegate = self;
    [peripheral discoverServices:FBBLE_SERVICE_UUID];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    isDiscoverServices = YES;
    NSLog(@"didDiscoverServices____Discovered service ");
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID],[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]] forService:service];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    isDiscoverCharacteristics = YES;
    NSLog(@"didDiscoverCharacteristicsForService____Discovered characteristic");
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
            [self setupSonThreadJJGCDTimerWithStartTimeSinceNow:0 interval:0.8 repeatcount:3];
        }else if([string isEqual: @"9000"]){
            [self disconnectPeripheral];
        }
    }
}






//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------

//---------------------------------------------------------------------------------

// 延时机制--断开设备
- (void)setupSonThreadDelayInSecond:(float)second{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.disconnectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.disconnectTimer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.disconnectTimer, ^{
        
        // 执行事件
        // NSLog(@"倒计时3秒");
        if (!isDiscoverPeripheral) {
            NSLog(@"setupSonThreadDelayInSecond------------扫描不到外设 %@", [NSThread currentThread]);
            [self disconnectPeripheral];
            dispatch_cancel(self.disconnectTimer);
            self.disconnectTimer = nil;
            
        }else if(!isConnectPeripheral){
            NSLog(@"setupSonThreadDelayInSecond------------连接不到外设 %@", [NSThread currentThread]);
            [self disconnectPeripheral];
            dispatch_cancel(self.disconnectTimer);
            self.disconnectTimer = nil;
            
        }else if(!isDiscoverServices){
            NSLog(@"setupSonThreadDelayInSecond------------搜索不到外设服务 %@", [NSThread currentThread]);
            [self disconnectPeripheral];
            dispatch_cancel(self.disconnectTimer);
            self.disconnectTimer = nil;
            
        }else if(!isDiscoverCharacteristics){
            NSLog(@"setupSonThreadDelayInSecond------------搜索不到特征值 %@", [NSThread currentThread]);
            [self disconnectPeripheral];
            dispatch_cancel(self.disconnectTimer);
            self.disconnectTimer = nil;
        }
        
    });
    
    dispatch_resume(self.disconnectTimer);
    
}

// 重发机制--重发开锁命令
- (void)setupSonThreadJJGCDTimerWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.timer, ^{
        // 执行事件
        if (myPeripheral && myWritableCharacteristic) {
            // 重发3次开锁命令

            [myPeripheral writeValue:[self unlockCommand] forCharacteristic:myWritableCharacteristic type:1];
            NSLog(@"unlockCommand");
     
        
        }
        
        count++;
        if (count == repeatcount) {
            // 重发3次仍然失败
            if (myPeripheral && myWritableCharacteristic) {
                [myPeripheral writeValue:[self disconnectCommand] forCharacteristic:myWritableCharacteristic type:1];
                NSLog(@"disconnectCommand");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"centralble" object:nil];
            }
            
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
    });
    
    dispatch_resume(self.timer);
}


- (NSData*)disconnectCommand{
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


- (NSData*)unlockCommand{
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

