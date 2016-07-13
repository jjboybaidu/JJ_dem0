//
//  ViewController.m
//  JJViewController
//
//  Created by farbell-imac on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "ViewController.h"
#import "JJFormat.h"
#import "JJShakeble.h"
#import "JJCoreMotion.h"

@interface ViewController ()

@end

@implementation ViewController{
    JJShakeble *shakeble;
    JJCoreMotion *coremotion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup JJFormat
    // [self setupJJFormat];
    
    // setup JJShakeble
    [self setupJJShaekble];
    
    // setup JJCoreMotin
    // [self setupJJCoreMotion];
}

// setupJJFormat
- (void)setupJJFormat{
    NSData *data = [JJFormat formatTotNSDataTimeWithCurrentTime];
    NSLog(@"%@",data);
    [JJFormat formatToCurrentTimeWithNSDataTime:data];
}

// setupJJShakeble
- (void)setupJJShaekble{
    shakeble = [[JJShakeble alloc]init];
    [shakeble setupMotionManager];
}

// setupJJCoreMotion
- (void)setupJJCoreMotion{
    coremotion = [[JJCoreMotion alloc]init];
    [coremotion setupAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
