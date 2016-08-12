//
//  JJGCDSource.m
//  JJGCDTimer
//
//  Created by farbell-imac on 16/8/12.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJGCDSource.h"

@interface JJGCDSource()

@property (nonatomic, strong) dispatch_source_t source;
// @property (nonatomic, retain) int count;

@end

@implementation JJGCDSource{
    long count;
}

- (void)setupJJGCDSource{
    
    // setupDispatchSourceTypeDataAdd
    [self setupDispatchSourceTypeDataAdd];
}

// setupDispatchSourceTypeDataAdd(用户自定义的事件－变量相加)
- (void)setupDispatchSourceTypeDataAdd{
    
    count = 0;
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建 Dispatch Source，种类为DISPATCH_SOURCE_TYPE_DATA_ADD，即获取到的变量会相加
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);
    
    //配置 Dispatch Source 的回调 block，即当收到该 Source 事件时候，就把该 block 追加到对应的queue中
    dispatch_source_set_event_handler(self.source, ^{
        UInt64 value = dispatch_source_get_data(self.source);
        count += value;
        NSLog(@"n = %ld",(long)count);
        
    });
    
    //启动 Source， Source 默认是 suspend 的，需要手动启动
    dispatch_resume(self.source); 
}





// 参考代码
- (void)reference{
 
}

@end
