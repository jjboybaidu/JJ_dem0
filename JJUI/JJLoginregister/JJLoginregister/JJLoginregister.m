//
//  JJLoginregister.m
//  JJLoginregister
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJLoginregister.h"

@interface JJLoginregister ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation JJLoginregister

- (IBAction)dismissLoginRegisterVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginOrRegister:(UIButton *)button {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { // 显示注册界面
        self.loginViewLeftMargin.constant = - self.view.frame.size.width;
        // 切换按钮文字方法1：结合xib设置按钮选中状态下的文字，到xib设置文字
        button.selected = YES;
        // 切换按钮文字方法2：
        //                [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    } else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        // 切换按钮文字方法1：
        button.selected = NO;
        // 切换按钮文字方法2：
        //                [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
