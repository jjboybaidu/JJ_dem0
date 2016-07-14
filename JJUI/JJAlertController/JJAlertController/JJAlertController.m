//
//  JJAlertController.m
//  JJAlertController
//
//  Created by farbell-imac on 16/7/14.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJAlertController.h"

@implementation JJAlertController

- (UIAlertController *)setupAlertController{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"警告框" message:@"请赶快报警" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:cancelaction];
    
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:okaction];
    
    return alertcontroller;
}

- (UIAlertController *)setupDestoryAlertController{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"警告框" message:@"请赶快报警" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:cancelaction];
    
    UIAlertAction *destructiveaction = [UIAlertAction actionWithTitle:@"毁灭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:destructiveaction];
    
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:okaction];
    
    return alertcontroller;
}

- (UIAlertController *)setupActionSheetAlertController{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:nil message:@"Takes the appearance of the bottom bar if specified; otherwise, same as UIActionSheetStyleDefault." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:cancelaction];
    
    UIAlertAction *destructiveaction = [UIAlertAction actionWithTitle:@"毁灭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:destructiveaction];
    
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertcontroller addAction:okaction];
    
    return alertcontroller;
}

@end
