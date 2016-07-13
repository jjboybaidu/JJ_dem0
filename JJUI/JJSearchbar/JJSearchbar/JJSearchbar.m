//
//  JJSearchbar.m
//  JJSearchbar
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJSearchbar.h"

@implementation JJSearchbar

+ (instancetype)searchBar{
    return [[self alloc]init];// 就是返回创建一个textfield
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);// 设置左边图标的尺寸
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.background = [UIImage resizedImageWithName:@"JJSearchbar"];// 给UITextField添加背景
        // 在UITextField的左边添加放大镜图标
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"JJSearchbar_icon"]];
        iconView.frame = CGRectMake(0, 0, 30, 30);
        iconView.contentMode = UIViewContentModeCenter; // 把放大镜图标居中显示
        self.leftView = iconView;// self指的是UITextField
        self.leftViewMode = UITextFieldViewModeAlways;// 总是展示这个view
        self.font = [UIFont systemFontOfSize:13]; // UITextField的字体
        self.clearButtonMode = UITextFieldViewModeAlways;// 在UITextField的右边添加清除按钮
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索" attributes:attrs];// 设置placeholder提醒文字
    }
    
    return self;
}

@end
