//
//  JJQuartz2D.m
//  JJQuartz2D
//
//  Created by WilliamLiuWen on 16/8/11.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJQuartz2D.h"

@implementation JJQuartz2D

- (void)drawRect:(CGRect)rect{
    [self setupJJQuartz2D:rect];
}

- (void)setupJJQuartz2D:(CGRect)rect{
    
    // drawYellowMan
    [self drawYellowMan:rect];
}


// 画一条线
- (void)drawLine{
    
}

// 画一个圆
- (void)drawCicle{
    
}

// 画一个三角形
- (void)drawTrangel{
    
}

// 画一个小黄人
- (void)drawYellowMan:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画胶囊身体
    CGFloat headX = rect.size.width * 0.5;
    CGFloat headY = 100;
    CGFloat headRadius = 50;
    CGContextAddArc(ctx, headX, headY, headRadius, 0, -M_PI, 1);
    CGFloat lineLeftPointX = headX - headRadius;
    CGFloat lineLeftPointY = 200;
    CGContextAddLineToPoint(ctx, lineLeftPointX, lineLeftPointY);
    CGFloat bottomX = headX;
    CGFloat bottomY = lineLeftPointY;
    CGFloat bottomRadius = headRadius;
    CGContextAddArc(ctx, bottomX, bottomY, bottomRadius, -M_PI, 0, 1);
    [[UIColor yellowColor]set];
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    // 画眼睛框-黑色绑带
    CGFloat BangDaiPointX = headX + headRadius;
    CGFloat BangDaiPointY = headY;
    CGContextMoveToPoint(ctx,BangDaiPointX, BangDaiPointY);
    CGFloat BangDaiPoint2X = headX - headRadius;
    CGFloat BangDaiPoint2Y = BangDaiPointY;
    CGContextAddLineToPoint(ctx, BangDaiPoint2X, BangDaiPoint2Y);
    CGContextSetLineWidth(ctx, 10);
    [[UIColor blackColor]set];
    CGContextStrokePath(ctx);
    // 画眼睛框-镜框
}


@end
