//
//  JJBlockBviewController.m
//  JJViewController
//
//  Created by farbell-imac on 16/8/11.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJBlockBviewController.h"

@interface JJBlockBviewController()



@end

@implementation JJBlockBviewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    [self setupBviewController];
}

- (void)setupBviewController{
    
    float btnwidth = 200;
    float btnheight = 50;
    
    float phoneTextfieldwidth = 200;
    float phoneTextfieldheight = 50;
    float phoneTextfieldx = (self.view.frame.size.width - btnwidth)/2;
    float phoneTextfieldy = self.view.center.y-150 + btnheight;
    self.phoneTextfield = [[UITextField alloc]initWithFrame:CGRectMake(phoneTextfieldx, phoneTextfieldy, phoneTextfieldwidth, phoneTextfieldheight)];
    [self.phoneTextfield setPlaceholder:@"请输入电话号码"];
    [self.view addSubview:self.phoneTextfield];
    
    
    float nameTextfieldwidth = 200;
    float nameTextfieldheight = 50;
    float nameTextfieldx = (self.view.frame.size.width - btnwidth)/2;
    float nameTextfieldy = self.view.center.y-150 + btnheight + phoneTextfieldheight;
    self.nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(nameTextfieldx, nameTextfieldy, nameTextfieldwidth, nameTextfieldheight)];
    [self.nameTextfield setPlaceholder:@"请输入姓名"];
    [self.view addSubview:self.nameTextfield];
    
}


// 触摸B，回退到A
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController popViewControllerAnimated:YES];
    
    // transferStringValue
    // [self transferStringValue];
    
    // transferColorValue
    // [self transferColorValue];
    
    // transferGroupValue
    [self transferGroupValue];
}


// transferGrounpValue
- (void)transferGroupValue{
    if (self.JJBlockBviewControllerBlockGroup) {
        self.JJBlockBviewControllerBlockGroup(self.phoneTextfield.text,self.nameTextfield.text);
    }
}


// transferStringValue
- (void)transferStringValue{
    // 感觉就像代理传值一样，这里是执行自己的block方法
    if (self.JJBlockBviewControllerBlock) {
        self.JJBlockBviewControllerBlock(@"bValueToa");
    }
}


// transferColorValue
- (void)transferColorValue{
    if (self.backgroundColor) {
        self.backgroundColor([UIColor redColor]);
    }
}



@end
