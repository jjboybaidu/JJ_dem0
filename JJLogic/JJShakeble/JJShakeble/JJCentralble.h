//
//  JJCentralble.h
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJCentralble : NSObject
+ (instancetype)getInstance;

- (void)initWithCentral;

/**
 *启动蓝牙服务
 */
- (void)startService;

/**
 *停止蓝牙服务
 */
- (void)stopService;

@end
