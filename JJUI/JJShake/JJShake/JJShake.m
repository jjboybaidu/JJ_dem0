//
//  JJShake.m
//  JJShake
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJShake.h"

@implementation JJShake

#pragma mark 第一步：开始摇动
// 开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始摇动");
}

#pragma mark 第二步：取消摇动
// 取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"取消摇动");
}

#pragma mark 第三步：摇动结束
// 摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇动结束");
}

@end
