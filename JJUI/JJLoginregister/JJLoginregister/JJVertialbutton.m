//
//  JJVertialbutton.m
//  JJLoginregister
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJVertialbutton.h"

@implementation JJVertialbutton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

// 从代码创建button的时候会用到下面的代码
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

// 从xib加载的时候会用到下面的代码
- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.frame.origin.x = 0;
    self.imageView.frame.origin.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 5;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
