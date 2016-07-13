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

#ifdef DEBUG
#define FBLog(...) NSLog(__VA_ARGS__)
#else
#define FBLog(...)
#endif

#define FBFUNC FBLog(@"%s",__func__);
#define FBBLE_PERIPHERALS_NAME           @"TrudBleAcces"
#define FBBLE_UNLOCK_SUCCESS             @"36864"
#define FBBLE_SERVICE_UUID               @"FFF0"
#define FBBLE_CHARACTERISTICS_LOCALUUID  @"FFF5"
#define FBBLE_CHARACTERISTICS_WRITEUUID  @"FFF6"

@interface JJCentralble()<CBPeripheralDelegate,CBCentralManagerDelegate>

@property(nonatomic,strong)NSMutableArray* blackNameArray;

@end

@implementation JJCentralble{
    CBCentralManager *myCentralManager;
    CBPeripheral *myPeripheral;
    CBCharacteristic *myWritableCharacteristic;
    CBCharacteristic *myLocalIDCharacteristic;
    int writecount;
    int updatecount;
    int unlockcount;
    NSTimer* BLETimer;
}

- (NSMutableArray *)blackNameArray{
    if (_blackNameArray == nil) {
        _blackNameArray = [NSMutableArray array];
    }
    return _blackNameArray;
}

//create a central manager
- (void)initWithCentral{
    //By specifying the dispatch queue as nil, the central manager dispatches central role events using the main queue
    if(myCentralManager == nil){
        myCentralManager = [[CBCentralManager alloc]initWithDelegate:self
                                                               queue:dispatch_get_global_queue(0, 0)
                                                             options:nil];
        
        NSDate * BLEFutureDate = [NSDate dateWithTimeIntervalSinceNow:0.001];
        BLETimer = [[NSTimer alloc] initWithFireDate:BLEFutureDate
                                                      interval:1.8
                                                        target:self
                                                      selector:@selector(scan)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    
}

/**
 *启动蓝牙服务
 */
-(void)startService{
    
    if(myCentralManager == nil){
        [self initWithCentral];
    }
    
    if(myCentralManager.isScanning == NO){
        [self cycleScan];
    }
}


/**
 *停止蓝牙服务
 */
-(void) stopService{
    
    if(BLETimer != nil){
        [BLETimer invalidate];
    }
}


#pragma mark - CentralManagerDelegate
//When you create a central manager, the central manager calls the centralManagerDidUpdateState: method of its delegate object.
//@required
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn){
        [myCentralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:FBBLE_SERVICE_UUID]]
                                                 options:nil];
    }
    if (central.state == CBCentralManagerStatePoweredOff) {
        [myCentralManager stopScan];
        NSLog(@"CBCentralManagerStatePoweredOff");
    }
}

//the central manager calls the centralManager:didDiscoverPeripheral:advertisementData:RSSI: method of its delegate object each time a peripheral is discovered.
//After you have discovered a peripheral device that is advertising services you are interested in, you can request a connection to the peripheral by calling the connectPeripheral:options: method of the CBCentralManager class.
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                  RSSI:(NSNumber *)RSSI{
    //Backup:"  && [peripheral.identifier.UUIDString isEqualToString:@"1C9F1F29-70CB-806A-3DEE-464A17F49178"]   "
   if (self.blackNameArray.count > 0 && [peripheral.name isEqualToString:FBBLE_PERIPHERALS_NAME]){
        for (NSString *string in self.blackNameArray) {
            if (![peripheral.identifier.UUIDString isEqualToString: string]) {
                [myCentralManager stopScan];
                FBLog(@"DidDiscoverPeripheral scanning stopped");
                myPeripheral = peripheral;
                [myCentralManager connectPeripheral:peripheral options:nil];
            }
        }
    }
    if ([peripheral.name isEqualToString:FBBLE_PERIPHERALS_NAME] && self.blackNameArray.count == 0 ) {
        [myCentralManager stopScan];
        FBLog(@"DidDiscoverPeripheral scanning stopped");
        myPeripheral = peripheral;
        [myCentralManager connectPeripheral:peripheral options:nil];
    }
}

//Assuming that the connection request is successful, the central manager calls the centralManager:didConnectPeripheral: method of its delegate object, which you can implement to log that the connection is established
//After you have established a connection to a peripheral, you can begin to explore its data. The first step in exploring what a peripheral has to offer is discovering its available services.
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral{
    FBLog(@"Peripheral connected");
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:FBBLE_SERVICE_UUID]]];
}

//When the specified services are discovered, the peripheral (the CBPeripheral object you’re connected to) calls the peripheral:didDiscoverServices: method of its delegate object.
//Discovering all of the characteristics of a service is as simple as calling the discoverCharacteristics:forService: method of the CBPeripheral class
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(nullable NSError *)error{
    for (CBService *service in peripheral.services){
        FBLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID],[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]] forService:service];
    }
}

//The peripheral calls the peripheral:didDiscoverCharacteristicsForService:error: method of its delegate object when the characteristics of the specified service are discovered.
//You can retrieve the value of a characteristic by reading it directly or by subscribing to it
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(nullable NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics){
        FBLog(@"Discovered characteristic %@", characteristic);
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

//When you attempt to read the value of a characteristic, the peripheral calls the peripheral:didUpdateValueForCharacteristic:error: method of its delegate object to retrieve the value.
//If you try to read a value that is not readable, the peripheral:didUpdateValueForCharacteristic:error: delegate method returns a suitable error.
//Each time the value changes, the peripheral calls the peripheral:didUpdateValueForCharacteristic:error: method of its delegate object.
-(void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
            error:(NSError *)error{
    //    NSLog(@"特征值myLocalIDCharacteristic is %@ %d",myLocalIDCharacteristic.value,updatecount);//FirstTime is <87654321 87654321>;SecondTime is <87654321 87654321>.
    //    NSLog(@"特征值myWritableCharacteristic is %@ %d",myWritableCharacteristic.value,updatecount);//FirstTime is null;SecondTime is <00810000 00>.
    
    if ( [characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID] ] ){
        NSString *string = [JJFormat formatToHexadecimalStringWithNSData:characteristic.value];
        if (string != nil && ![string isEqual: @"9000"]) {//Read first is null;When string is nil ,we should't write data;When string is @"9000",we needn't write data.
            
            
//            FBLong localNodeId;
//            localNodeId.val = [self authorLocalID];
//            NSLog(@"［FBBLECentral］ 当前的LocalID:%llu",localNodeId.val);
            
            [self writeData];
            
//            if( [[FBNodeManager getInstance]isExistNode:localNodeId nodeType:FB_NODETYPE_DOOR] == YES){
//                 NSLog(@"［FBBLECentral］ 当前的LocalID:%llu, 授权开门",localNodeId.val);
//                [self writeData];
//            }else{
//                NSLog(@"［FBBLECentral］ 当前的LocalID:%llu, 无权限授权",localNodeId.val);
//
//                [self.blackNameArray addObject:peripheral.identifier.UUIDString];
//
//            }
        }else if([string isEqual: @"9000"]){
            writecount = 0;
            unlockcount ++;
            NSLog(@"KO___________________________________Success Unlock %d time",unlockcount);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"centralble" object:nil];
            [myCentralManager cancelPeripheralConnection:peripheral];
        }
    }
}

//When you subscribe to a characteristic’s value, you receive a notification from the peripheral when the value changes.
//You can subscribe to the value of a characteristic that you are interested in by calling the setNotifyValue:forCharacteristic: method of the CBPeripheral class
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
}

//When cancel
- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error{
    if (peripheral) peripheral = nil;
}

//If a characteristic’s value is writeable, you can write its value with some data (an instance of NSData) by calling the writeValue:forCharacteristic:type: method of the CBPeripheral class
//the write type is specified as CBCharacteristicWriteWithResponse, which indicates that the peripheral lets your app know whether the write is successful.
//When write data,I readValue immeditaly,if no success ,I write data again.
- (void)writeData{
    writecount++;
    FBLog(@"Writecount %d",writecount);
    if (writecount < 4) {
        [myPeripheral writeValue:[self unlockCommand]
               forCharacteristic:myWritableCharacteristic
                            type:1];
        NSLog(@"Write data %d time",writecount);
        [myCentralManager stopScan];
        FBLog(@"WriteData scanning stopped");
        [NSThread sleepForTimeInterval:0.5];
        [myPeripheral readValueForCharacteristic:myWritableCharacteristic];
    }else{
        writecount = 0;
        [myPeripheral writeValue:[self disconnectCommand]
               forCharacteristic:myWritableCharacteristic
                            type:1];
    }
}

//Juge right LocalID
- (unsigned long long)authorLocalID{
    NSString *stringH = [JJFormat formatToHexadecimalStringWithNSData:myLocalIDCharacteristic.value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    unsigned long long myLocalIDValue =   [[formatter numberFromString:stringH]unsignedLongLongValue];
    return myLocalIDValue;
}

//The peripheral responds to write requests that are specified as CBCharacteristicWriteWithResponse by calling the peripheral:didWriteValueForCharacteristic:error: method of its delegate object. If the write fails for any reason, you can implement this delegate method to access the cause of the error
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
       didReadRSSI:(NSNumber *)RSSI
             error:(NSError *)error{
    if (error) {
        NSLog(@"DidReadRSSI Error %@",error);
    }
}

- (void)cycleScan{//Cycle do something
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop * BLERunLoop = [NSRunLoop currentRunLoop];
        [BLERunLoop addTimer:BLETimer forMode:NSDefaultRunLoopMode];
        [BLERunLoop run];
    });
}

- (void)scan{
    writecount = 0;
    [myCentralManager stopScan];
    if (!myCentralManager.isScanning) {
        [myCentralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:FBBLE_SERVICE_UUID]]
                                                 options:nil];
    }
}

//Creat disconnect command
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

//Create unlock command
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

