//
//  JJCommandNetwork.h
//  JJCommand
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJCommandNetworkData;

@protocol JJCommandNetworkDelegate <NSObject>
@optional
- (void)handleNetworkData:(JJCommandNetworkData *)networkData;
@end


@interface JJCommandNetwork : NSObject
+ (instancetype) getInstance;
- (void)setupNetwork;
- (void)sendData:(JJCommandNetworkData *)networkData;
@property(nonatomic,weak)id<JJCommandNetworkDelegate>delegate;

@end
