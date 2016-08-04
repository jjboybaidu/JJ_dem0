//
//  JJHideKeyboard.m
//  JJHideKeyboard
//
//  Created by WilliamLiuWen on 16/8/3.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJHideKeyboard.h"

@implementation JJHideKeyboard

// 使用方法：替换控制器的View
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    [self endEditing:YES];
    return result;
}

@end
