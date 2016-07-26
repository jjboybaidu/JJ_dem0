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

@end
