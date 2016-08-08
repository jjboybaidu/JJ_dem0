//
//  JJDelegateBviewController.h
//  JJDelegate
//
//  Created by WilliamLiuWen on 16/8/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJDelegateBviewControllerDelegate<NSObject>

- (void)bValueToA:(NSString*)value;

@end

@interface JJDelegateBviewController : UIViewController

@property (nonatomic, assign) id<JJDelegateBviewControllerDelegate> delegate;

@end
