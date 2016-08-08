//
//  JJDelegateBviewController.m
//  JJDelegate
//
//  Created by WilliamLiuWen on 16/8/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJDelegateBviewController.h"

@interface JJDelegateBviewController ()

@end

@implementation JJDelegateBviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self touch];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touch{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bValueToA:)]) {
        // 如果代理实现了bValueToA方法就会拿到下面传过去的值，通过代理方法参数传值，代理传值就是参数传值
        [self.delegate bValueToA:@"action moive very good"];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
