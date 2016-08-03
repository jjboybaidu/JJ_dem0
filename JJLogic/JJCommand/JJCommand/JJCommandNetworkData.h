//
//  JJCommandNetworkData.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCommandParam.h"

@interface JJCommandNetworkData : NSObject
@property(nonatomic) NSString        *host;//
@property(nonatomic) DWORD           port;
@property(nonatomic) NSData          *data;// 网络数据
@property(nonatomic) long            tag;

@end
