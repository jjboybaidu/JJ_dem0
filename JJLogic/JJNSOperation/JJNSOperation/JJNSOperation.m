//
//  JJNSOperation.m
//  JJNSOperation
//
//  Created by farbell-imac on 16/7/25.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJNSOperation.h"

@implementation JJNSOperation

// Operation直接执行不需要queue,且是串行，如果只重写main方法，因为NSOperation是默认非并发的，所以会block住该线程
- (void)main {
    @autoreleasepool {
        if (self.isCancelled) return;
        
        if (self.isCancelled) {
           return; }
        NSLog(@"MAIN....");
        
    }
}

// Operation直接执行不需要queue,且是并发，并发的Operation
- (BOOL)isConcurrent {
    return YES;
}
- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    // _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self finish];
}
- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    // _isExecuting = NO;
    // _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setupJJNSOperation{
    
    // [self setupNSOperationDependance];
    
    // [self setupJJBlockOperation];
    
    // [self setupJJBlockOperationMore];
    
    // [self setupJJInvocationOperation];
    
    [self setupJJMainQueueOperation];
    
    [self setupJJQueueOperation];
}


// NSOperation 依赖上一个任务
- (void)setupNSOperationDependance{
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一：下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务二：打水印   - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务三：上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
}

// NSOperation 依赖同一个任务
- (void)setupNSOperationDependanceSame{
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一：下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务二：打水印   - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务三：上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务四：我在谁后面呢？？ - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    [operation4 addDependency:operation2];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1,operation4] waitUntilFinished:NO];
}

- (void)setupJJBlockOperation{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"setupJJBlockOperation %@", [NSThread currentThread]);
    }];
    [operation start];
}

- (void)setupJJBlockOperationMore{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    for (NSInteger i = 0; i < 5; i++) {//添加多个Block
        [operation addExecutionBlock:^{
            NSLog(@"第%ld次：%@", i, [NSThread currentThread]);// 会在不同线程执行
        }];
    }
    [operation start];
}

// 使用InvocationOperation
- (void)setupJJInvocationOperation{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [operation start];
}
- (void)run{
    NSLog(@"setupJJInvocationOperation %@", [NSThread currentThread]);
}

// 任务被添加到并发队列
- (void)setupJJQueueOperation{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"setupJJQueueOperation %@", [NSThread currentThread]);
        
    }];
    [[[NSOperationQueue alloc] init] addOperation:operation];//并发队列
}

// 任务被添加到主队列
- (void)setupJJMainQueueOperation{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"setupJJMainQueueOperation %@", [NSThread currentThread]);
        
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];//主队列==串行队列
}

@end
