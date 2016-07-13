//
//  JJBLECentralManager.m
//  JJBLECentralManager
//
//  Created by WilliamLiuWen on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJBLECentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface JJBLECentralManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation JJBLECentralManager{
    CBCentralManager *myCentralManager;
    CBPeripheral *myPeripheral;
}

//create a BLE central manager
- (void)setupBLECentralManager{
    //By specifying the dispatch queue as nil, the central manager dispatches central role events using the main queue
    NSLog(@"setupBLECentralManager");
    myCentralManager = [[CBCentralManager alloc]initWithDelegate:self
                                                           queue:dispatch_get_global_queue(0, 0)
                                                         options:nil];
}

#pragma mark - CentralManagerDelegate
//When you create a central manager, the central manager calls the centralManagerDidUpdateState: method of its delegate object.
//@required
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn){
        [myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

//the central manager calls the centralManager:didDiscoverPeripheral:advertisementData:RSSI: method of its delegate object each time a peripheral is discovered.
//After you have discovered a peripheral device that is advertising services you are interested in, you can request a connection to the peripheral by calling the connectPeripheral:options: method of the CBCentralManager class.
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                  RSSI:(NSNumber *)RSSI{
    myPeripheral = peripheral;
    [myCentralManager connectPeripheral:peripheral options:nil];
}

//Assuming that the connection request is successful, the central manager calls the centralManager:didConnectPeripheral: method of its delegate object, which you can implement to log that the connection is established
//After you have established a connection to a peripheral, you can begin to explore its data. The first step in exploring what a peripheral has to offer is discovering its available services.
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

//When the specified services are discovered, the peripheral (the CBPeripheral object you’re connected to) calls the peripheral:didDiscoverServices: method of its delegate object.
//Discovering all of the characteristics of a service is as simple as calling the discoverCharacteristics:forService: method of the CBPeripheral class
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(nullable NSError *)error{
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//The peripheral calls the peripheral:didDiscoverCharacteristicsForService:error: method of its delegate object when the characteristics of the specified service are discovered.
//You can retrieve the value of a characteristic by reading it directly or by subscribing to it
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(nullable NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics){
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}

//When you attempt to read the value of a characteristic, the peripheral calls the peripheral:didUpdateValueForCharacteristic:error: method of its delegate object to retrieve the value.
//If you try to read a value that is not readable, the peripheral:didUpdateValueForCharacteristic:error: delegate method returns a suitable error.
//Each time the value changes, the peripheral calls the peripheral:didUpdateValueForCharacteristic:error: method of its delegate object.
-(void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
            error:(NSError *)error{

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

@end

