//
//  JJNewFeaturecell.m
//  JJNewFeature
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//  NewFeatureCell add thress view,one is shareButton,two is startButton,thress is imageview

#import "JJNewFeaturecell.h"

@interface JJNewFeaturecell()

@property (nonatomic, weak) UIImageView *imageView;// imageview
@property (nonatomic, weak) UIButton *shareButton;// sharebutton
@property (nonatomic, weak) UIButton *startButton;// startbutton

@end

@implementation JJNewFeaturecell


#pragma mark 创建------分享按钮
- (UIButton *)shareButton{
    if (_shareButton == nil) {
        // 设置shareButton的属性
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"JJ_newfeature_start_btn"] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"JJ_newfeature_start_btn"] forState:UIControlStateHighlighted];
        shareBtn.frame = CGRectMake(0, 0, 120, 40);
        // [startBtn sizeToFit];
        [shareBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];// clict startbutton response start func
        [self.contentView addSubview:shareBtn];
        _shareButton = shareBtn;
        
    }
    return _shareButton;
}


#pragma mark 创建------开始按钮
- (UIButton *)startButton{
    if (_startButton == nil) {
        // 设置startBtn的属性
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"JJ_newfeature_start_btn"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"JJ_newfeature_start_btn"] forState:UIControlStateHighlighted];
        startBtn.frame = CGRectMake(0, 0, 120, 40);
        // [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];// clict startbutton response start func
        [self.contentView addSubview:startBtn];
        _startButton = startBtn;
        
    }
    return _startButton;
}


#pragma mark 懒加载------imageView
- (UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        _imageView = imageV;
        // 注意:一定要加载contentView
        // 整个背后都是cell，要往cell的contentView上加东西
        // 所以iamge要在在contentView上面
        [self.contentView addSubview:imageV];
    }
    return _imageView;
}


#pragma mark 子控件------位置
// 布局子控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    // 分享按钮
    self.shareButton.center = CGPointMake(self.imageView.frame.size.width * 0.5, self.imageView.frame.size.height * 0.8);
    // 开始按钮
    self.startButton.center = CGPointMake(self.imageView.frame.size.width * 0.5, self.imageView.frame.size.height * 0.9);
}


#pragma mark 重写------setImage
// 外部类可以拿到这个属性设置新特性界面的图片
// 使用点语法，就是set方法的调用
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}


// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
    }
}

// 点击开始按钮的时候调用
- (void)start{
    //    // 进入tabBarVc
    //    mWBTabBarController2 *tabBarVc = [[mWBTabBarController2 alloc] init];
    //
    //    // 切换根控制器:可以直接把之前的根控制器清空
    //    mWBKeyWindow.rootViewController = tabBarVc;
    NSLog(@"start");
}

- (void)share{
    NSLog(@"share");
}

@end
