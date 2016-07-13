//
//  JJAddressbook.h
//  JJAddressbook
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
// 调用：
/*
 1.到AppDelegate
 2.导入头文件：#import "FBContactVC.h"
 3.
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
 self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
 FBContactVC *tabBarVc = [[FBContactVC alloc] init];
 self.window.rootViewController = tabBarVc;
 [self.window makeKeyAndVisible];
 
 
 return YES;
 }
 
 
 */

#import <UIKit/UIKit.h>

@interface JJAddressbook : UITableViewController

@end
