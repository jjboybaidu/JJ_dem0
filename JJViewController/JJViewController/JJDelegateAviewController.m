//
//  JJDelegateAviewController.m
//  JJDelegate
//
//  Created by WilliamLiuWen on 16/8/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJDelegateAviewController.h"
#import "JJDelegateBviewController.h"

@interface JJDelegateAviewController ()<JJDelegateBviewControllerDelegate>

@end

@implementation JJDelegateAviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // setupJJDelegateBviewController
    [self setupJJDelegateBviewController];
}

- (void)setupJJDelegateBviewController{
    JJDelegateBviewController *bViewController = [[JJDelegateBviewController alloc]init];
    bViewController.delegate = self;
    [self.navigationController pushViewController:bViewController animated:YES];
}

- (void)bValueToA:(NSString *)value{
    NSLog(@"%@",value);
}

// B 传值给 A，就是A做B的代理处理B传过来的值

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
