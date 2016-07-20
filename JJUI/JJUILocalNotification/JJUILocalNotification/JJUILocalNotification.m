//
//  JJUILocalNotification.m
//  JJUILocalNotification
//
//  Created by WilliamLiuWen on 16/7/20.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJUILocalNotification.h"

@implementation JJUILocalNotification

- (void)setupLocalNotification{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    // localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    // localNotif.timeZone = [NSTimeZone defaultTimeZone];
    // localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    // localNotif.alertTitle = NSLocalizedString(@"Item Due", nil);
    localNotif.alertBody = @"开门成功";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"dictionary" forKey:@"key"];
    localNotif.userInfo = infoDict;
    
    //  设置好本地推送后必须调用此方法启动此推送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
