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
#import "JJAlertController.h"

@interface ViewController ()

@end

@implementation ViewController{
    JJShakeble *shakeble;
    JJCoreMotion *coremotion;
    UIAlertController* alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup JJFormat
    // [self setupJJFormat];
    
    // setup JJShakeble
    // [self setupJJShaekble];
    
    // setup JJCoreMotin
    // [self setupJJCoreMotion];
    
    // setup button
    // [self setupButton];
    
    
}

// setupButton
- (void)setupButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 50, 30)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"请点我" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goSystemSetting) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // setup JJAlertController
    // [self presentViewController:[self setupJJAlertController] animated:YES completion:^{   }];
    
    // goSystemSetting
    // [self goSystemSetting];
}

// goSystemSetting
- (void)goSystemSetting{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// setupJJAlertController
- (UIAlertController*)setupJJAlertController{
    JJAlertController *jjalertcontroller = [[JJAlertController alloc]init];
    
    // normalAlertController
    // alertController = [jjalertcontroller setupAlertController];
    
    // destrucitiveAlertController
    // alertController = [jjalertcontroller setupDestoryAlertController];
    
    // actionSheetAlertController
    alertController = [jjalertcontroller setupActionSheetAlertController];
    
    return alertController;
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
