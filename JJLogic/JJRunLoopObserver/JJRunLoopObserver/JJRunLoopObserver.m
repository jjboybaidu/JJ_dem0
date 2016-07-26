//
//  JJRunLoopObserver.m
//  JJRunLoopObserver
//
//  Created by farbell-imac on 16/7/19.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJRunLoopObserver.h"
@interface JJRunLoopObserver()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation JJRunLoopObserver{
    int count;
}


- (void)setupJJRunLoopObserver {
    
    // [self setupSonJJRunLoopObserver];
    
    // [self setupJJTimerRunLoopWithStatTime:0.01 interval:1];
    
}

// setupJJTimerRunLoop 后台常驻Timer
- (void)setupJJTimerRunLoop{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer* timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.01]
                                                    interval:0.1
                                                      target:self
                                                    selector:@selector(runTimer)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    });
    
}
- (void)runTimer{
    NSLog(@"runTimer__on thread %@",[NSThread currentThread]);
}


// setupJJTimerRunLoop 只执行4次，1秒执行一次
- (void)setupJJTimerRunLoopWithStatTime:(float)startTime interval:(float)interval{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:startTime]
                                                  interval:interval
                                                    target:self
                                                  selector:@selector(runTimerWithRepeatCount)
                                                  userInfo:nil
                                                   repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    });
    
}
- (void)runTimerWithRepeatCount{
    count ++;
    if (count == 4) {
        [self.timer invalidate];
    }
    NSLog(@"runTimer__on thread %@",[NSThread currentThread]);
}


- (void)setupSonJJRunLoopObserver{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
        CFRunLoopObserverContext context = {0 , (__bridge void *)(self), NULL, NULL, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserverCallBack, &context);

        if (observer) {
            CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
            CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
        }
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doFireTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });

}


void myRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    // NSLog(@"observer正在回调\n%@----%tu----%@", observer, activity, info);
    switch(activity){
        case kCFRunLoopEntry:
            NSLog(@"即将进入loop");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"即将处理timers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"即将处理sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将进入休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"刚从休眠中唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"即将退出loop");
            break;
        default:
            break;
    }
    
}


- (void)doFireTimer {
    count ++;
    NSLog(@"计时器回调第 %d 次",count);
}


//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------

/*
 *  @brief CFRunLoopObserverContext 用来配置CFRunLoopObserver对象行为的结构体
 typedef struct {
 CFIndex  version;
 void *   info;
 const void *(*retain)(const void *info);
 void (*release)(const void *info);
 CFStringRef  (*copyDescription)(const void *info);
 } CFRunLoopObserverContext;
 *
 *  @param version 结构体版本号，必须为0
 *  @param info 一个程序预定义的任意指针，可以再 run loop Observer 创建时为其关联。这个指针将被传到所有 context 多定义的所有回调中。
 *  @param retain 程序定义 info 指针的内存保留（retain）回调,可以为 NULL
 *  @param release 程序定义 info 指针的内存释放（release）回调，可以为 NULL
 *  @param copyDescription 程序定于 info 指针的 copy 描述回调，可以为 NULL
 *
 *  @since
 */


- (void)reference{
    
    // 例1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // NSLog(@"%@",[NSThread currentThread]);
        /* 获取当前线程的RunLoop:有的话就直接获取，没有的话就自动创建 每个线程都有一个RunLoop */
        NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
        /* 用来配置CFRunLoopObserver对象行为的结构体 */
        CFRunLoopObserverContext context = {0 , (__bridge void *)(self), NULL, NULL, NULL};
        /* 创建观察者 */
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserverCallBack, &context);
        /* 把观察者放到RunLoop,并设置RunLoop模式 ,这里用CFRunLoop访问RunLoop API */
        if (observer) {
            CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];// 把NSRunLoop转成CFRunLoop吗？
            CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);// 把创建好的observer添加到RunLoop中去
        }
        /* 创建定时源 每？秒回调一次doFireTimer方法 */
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doFireTimer) userInfo:nil repeats:YES];
        
        /* 启动RunLoop方法1 ---设置超时时间 */
        /* 启动RunLoop ?秒后结束RunLoop */
        // [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
#if 0
        /* 运行循环总共运行9秒 */
        NSInteger loopCount = 3;
        do {
            [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];// 3秒后运行RunLoop实际效果是每三秒进入一次当前 while 循环
            loopCount --;
        } while (loopCount);
#endif
        
        /* 启动RunLoop方法2 ---无条件循环 */
        // [myRunLoop run];
        
        /* 启动RunLoop方法3 ---超时+模式 */
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    
    
    
    
    
    
   // 例2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0.01];
        NSTimer* myTimer = [[NSTimer alloc] initWithFireDate:date
                                                    interval:0.1
                                                      target:self
                                                    selector:@selector(enumTaskTable)
                                                    userInfo:nil
                                                     repeats:YES];
        //必须获取当前currentRunLoop,是在当前线程
        NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
        //如果不addTimer，那当前的myTimer会加入到mainLoop
        [myRunLoop addTimer:myTimer forMode:NSDefaultRunLoopMode];
        //必须run
        [myRunLoop run];
        
    });
    
    
    

}

@end
