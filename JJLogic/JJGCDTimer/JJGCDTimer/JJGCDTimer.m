//
//  JJGCDTimer.m
//  JJGCDTimer
//
//  Created by farbell-imac on 16/7/22.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJGCDTimer.h"
#import "JJGCDSource.h"

@interface JJGCDTimer()
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@property(nonatomic,strong)JJGCDSource *gcdSource;
@end

@implementation JJGCDTimer

- (void)setupJJGCDTimer{
    
    // [self setupMainThreadJJGCDTimerWithStartTimeSinceNow:0.01 interval:0.5 repeatcount:5];
    
    // [self setupSonThreadJJGCDTimerWithStartTimeSinceNow:0 interval:0 repeatcount:1];
    
    // [self setupMainThreadDelayInSecond:3];
    
    // [self setupSonThreadDelayInSecond:4];
    
    // [self dely];
    
    // [self scheduledDely];
    
    // [self scheduledDelyWithRepeat];
    
    // [self changeThread];
    
    // [self changeThreadWithPerform];
    
    [self setupJJGCDSource];
}

- (void)setupJJGCDSource{
    self.gcdSource = [[JJGCDSource alloc]init];
    [self.gcdSource setupJJGCDSource];
}

// 子线程切换到主线程
- (void)changeThread{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // 执行耗时的异步操作...CODE
        NSLog(@"处理子线程工作");
        [NSThread sleepForTimeInterval:2];
        
       dispatch_async(dispatch_get_main_queue(), ^{
       // 回到主线程，执行UI刷新操作
        NSLog(@"处理主线程工作");
       });
        
    });
}

// 子线程切换到主线程:使用performSelectorOnMainThread（swift中不能用这个方法）
- (void)changeThreadWithPerform{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行耗时的异步操作...CODE
        NSLog(@"处理子线程工作");
        [NSThread sleepForTimeInterval:2];
        
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:NO];
        
    });
}
- (void)mainThread{
    // 回到主线程，执行UI刷新操作
    NSLog(@"处理主线程工作");
}



// 利用performSelector延时执行
- (void)dely{
    [self performSelector:@selector(delyRun) withObject:nil afterDelay:2.0];
}
- (void)delyRun{
    NSLog(@"delyRun");
}


// 利用scheduledTimerWithTimeInterval延时执行(延时执行一次，不重复)
- (void)scheduledDely{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scheduleDelyRun) userInfo:nil repeats:NO];
}
- (void)scheduleDelyRun{
    NSLog(@"scheduleDelyRun");
}

// 利用scheduledTimerWithTimeInterval延时执行(重复延时执行，可以达到每隔多少秒执行一次）
- (void)scheduledDelyWithRepeat{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scheduleDelyRunWithRepeat) userInfo:nil repeats:YES];
}
- (void)scheduleDelyRunWithRepeat{
    NSLog(@"scheduleDelyRunWithRepeat");
}


// 主线程：延迟2秒后执行1次
- (void)setupMainThreadDelayInSecond:(float)second{
    double delayInSeconds = second;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        //执行事件
        NSLog(@"setupMainThreadDelayInSecond------------%@", [NSThread currentThread]);
    });
}


// 子线程：延迟2秒后执行1次
- (void)setupSonThreadDelayInSecond:(float)second{
    double delayInSeconds = second;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^(void){
        //执行事件
        NSLog(@"setupSonThreadDelayInSecond------------%@", [NSThread currentThread]);
    });
}


// 主线程：2秒后隔2秒执行1次共执行多次
- (void)setupMainThreadJJGCDTimerWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{

    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.timer, ^{
        // 执行事件
        NSLog(@"setupMainThreadJJGCDTimerWithStartTimeSinceNow------------%@", [NSThread currentThread]);
        count++;
        if (count == repeatcount) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
    });
    
    dispatch_resume(self.timer);
}


// 子线程：2秒后隔2秒执行1次共执行多次
- (void)setupSonThreadJJGCDTimerWithStartTimeSinceNow:(float)satrttime interval:(float)intervaltime repeatcount:(int)repeatcount{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(satrttime * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(intervaltime * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    __block int count = 0;
    dispatch_source_set_event_handler(self.timer, ^{
        // 执行事件
        NSLog(@"setupSonThreadJJGCDTimerWithStartTimeSinceNow------------%@", [NSThread currentThread]);
        count++;
        if (count == repeatcount) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
        
    });
    
    dispatch_resume(self.timer);
}

// 使用dispatch_once创建单例
+ (JJGCDTimer *)shareInstance{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JJGCDTimer alloc]init];
    });
    return _instance;
}
+ (void)shareInstanceXX{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}


// 参考代码（无价值）
- (void)reference{
    __block int count = 0;
    
    // 获得主队列
    // dispatch_queue_t queue = dispatch_get_main_queue();
    // 获得子队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.5 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        count++;
        
        if (count == 5) {
            // 取消定时器
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}


@end
