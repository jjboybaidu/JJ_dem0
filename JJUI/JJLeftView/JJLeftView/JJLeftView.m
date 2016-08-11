//
//  JJLeftView.m
//  JJLeftView
//
//  Created by WilliamLiuWen on 16/8/11.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJLeftView.h"

@interface JJLeftView(){
    NSArray *_arData;
}
@property (nonatomic,weak) UIView *leftView;
@property (nonatomic,weak) UIView *rightView;
@property (nonatomic,weak) UIView *mainView;
@property (nonatomic,assign) BOOL *isDraging;

@end

@implementation JJLeftView

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addLeftChildView];
    // 监听,只能监听对象属性，不能是结构体
    // options 监听新值改变
    [_mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (_mainView.frame.origin.x < 0) {// 往左移动
        _rightView.hidden = NO;
        _leftView.hidden = YES;
    }else if (_mainView.frame.origin.x > 0){
        _rightView.hidden = YES;
        _leftView.hidden = NO;
    }
}

- (void)addLeftChildView{
    UIView *leftView = [[UIView alloc]initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftView];
    self.leftView = leftView;
    _arData = @[@"新闻", @"订阅", @"图片", @"视频", @"跟帖", @"电台"];
    __block float h = self.view.frame.size.height*0.7/[_arData count];
    __block float y = 0.15*self.view.frame.size.height;
    [_arData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         UIView *listV = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, h)];
         [listV setBackgroundColor:[UIColor clearColor]];
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, listV.frame.size.width - 60, listV.frame.size.height)];
         [l setFont:[UIFont systemFontOfSize:20]];
         [l setTextColor:[UIColor whiteColor]];
         [l setBackgroundColor:[UIColor clearColor]];
         [l setText:obj];
         [listV addSubview:l];
         [self.view addSubview:listV];
         y += h;
    
     }];
    
    UIView *rightView = [[UIView alloc]initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
    UIView *mainView = [[UIView alloc]initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

#warning 监听事件
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint currentPoint = [touch locationInView:self.view];
    // 获取上一个点
    CGPoint prePoint = [touch previousLocationInView:self.view];
    // x偏移量
    CGFloat offsetX = currentPoint.x - prePoint.x;
    // 获取主视图的frame
    _mainView.frame = [self getCurrentFrameWithOffsetX:offsetX];
    _isDraging = YES;
}

#define MaxY 80
// 调节MaxY可以控制缩放的比例
- (CGRect)getCurrentFrameWithOffsetX:(CGFloat)offsetX{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 获取y偏移量
    CGFloat offsetY = offsetX * MaxY / screenW;
    CGFloat scale = 0;
    
    if (_mainView.frame.origin.x < 0) {// 往左滑动
        
        scale = ( screenH + 2 * offsetY) / screenH;
        
    }else{
        
        scale = ( screenH - 2 * offsetY) / screenH;
    }
    
    // 获取之前的frame
    CGRect frame = _mainView.frame;
    frame.origin.x +=  offsetX;
    frame.size.height = frame.size.height *scale;
    frame.size.width = frame.size.width *scale;
    frame.origin.y = (screenH - frame.size.height) * 0.5;
    
    return frame;
}

// 左边滑动过来
#define RTarget 200
// 右边不设置滑动过来
//#define LTarget -120
// 定位点，作用，过了屏幕一半就定在那个拖得位置
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 没有拖拽，且主视图尺寸不会0的时候，点击结束时，把尺寸复原
    if (_isDraging == NO && _mainView.bounds.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _mainView.frame = self.view.bounds;
        }];
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 两边都可以拉出抽屉
    //    CGFloat target = 0;
    //    if (_mainView.frame.origin.x > screenW * 0.5){
    //        target = RTarget;
    //    }else if (CGRectGetMaxX(_mainView.frame) < screenW * 0.5){
    //        target = LTarget;
    //    }
    //
    //
    //    [UIView animateWithDuration:0.25 animations:^{
    //         if (target) {
    //        // 获取x偏移量
    //        CGFloat offsetX = target - _mainView.frame.origin.x;
    //
    //        // 设置当前主视图的frame
    //        _mainView.frame = [self getCurrentFrameWithOffsetX:offsetX];
    //
    //    }else{
    //        _mainView.frame = self.view.bounds;
    //    }
    //    }];
    
    //只有左边能拉出抽屉
    if (_mainView.frame.origin.x > screenW * 0.5){
        [UIView animateWithDuration:0.25 animations:^{
            // 获取x偏移量
            CGFloat offsetX = RTarget - _mainView.frame.origin.x;
            // 设置当前主视图的frame
            _mainView.frame = [self getCurrentFrameWithOffsetX:offsetX];
        }];
    }else{
        _mainView.frame = self.view.bounds;
    }
}

@end
