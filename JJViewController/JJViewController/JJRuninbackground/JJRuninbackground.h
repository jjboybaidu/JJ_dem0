//
//  JJRuninbackground.h
//  JJRuninbackground
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJRuninbackground : NSObject
+ (instancetype)sharedInstance;
- (void)startRunInbackGround;
- (void)stopAudioPlay;

@end










