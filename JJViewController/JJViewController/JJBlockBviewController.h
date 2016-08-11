//
//  JJBlockBviewController.h
//  JJViewController
//
//  Created by farbell-imac on 16/8/11.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//  谁定义Block就是谁要传值，就像谁定义代理就是谁要通过代理来传值

#import <UIKit/UIKit.h>

@interface JJBlockBviewController : UIViewController

@property(nonatomic,strong)UITextField *phoneTextfield;
@property(nonatomic,strong)UITextField *nameTextfield;



// 通过Block传了一个string字符串；创建一个对外的Block，这个Block是B的属性，Block里面还带有参数
@property (nonatomic, copy) void (^JJBlockBviewControllerBlock)(NSString *string);

// 通过Block传了一个color颜色
typedef void(^changeColor)(id);
@property (nonatomic, copy) changeColor backgroundColor;


// 通过Block传一组值
@property (nonatomic, copy) void (^JJBlockBviewControllerBlockGroup)(NSString *phone,NSString *name);

@end
