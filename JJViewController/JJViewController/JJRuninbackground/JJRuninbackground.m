//
//  JJRuninbackground.m
//  JJRuninbackground
//
//  Created by WilliamLiuWen on 16/7/9.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "JJRuninbackground.h"
#import <AVFoundation/AVFoundation.h>

@interface JJRuninbackground ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *audioTimer;

@end

@implementation JJRuninbackground

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setupAudioSession];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mysong" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.volume = 0.01;// 0.0~1.0,默认为1.0
        self.audioPlayer.numberOfLoops = -1; // 循环播放
    }
    
    return self;
}

- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if (error)  NSLog(@"Error setCategory AVAudioSession: %@", error);
    
    NSError *activeSetError = nil;
    [audioSession setActive:YES error:&activeSetError];
    if (activeSetError) NSLog(@"Error activating AVAudioSession: %@", activeSetError);
}


- (void)startRunInbackGround {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(startAudioPlay) userInfo:nil repeats:YES];
    // 如果不是主线程循环需要开启循环
    //    if ([NSRunLoop currentRunLoop] != [NSRunLoop mainRunLoop]) {
    //        [[NSRunLoop currentRunLoop] run];
    //    }
    // 默认
    self.audioTimer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)startAudioPlay {
    [self.audioPlayer play];
}

- (void)stopAudioPlay {
    [self.audioTimer invalidate];
    self.audioTimer = nil;
}








//________________________________________________________________________________________
//________________________________________________________________________________________
//________________________________________________________________________________________
//________________________________________________________________________________________
//________________________________________________________________________________________

/* 注释参考
 
 + (instancetype)sharedBg {// 提供一个单例
 static dispatch_once_t onceToken;
 static id instance;
 
 dispatch_once(&onceToken, ^{
 
 instance = [[self alloc] init];
 });
 
 return instance;
 }
 
 // 重写init方法，初始化音乐文件
 - (instancetype)init {
 
 if (self = [super init]) {
 
 [self setupAudioSession];
 // 播放文件
 NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mysong" ofType:@"mp3"];
 NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
 self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
 [self.audioPlayer prepareToPlay];
 self.audioPlayer.volume = 0.01;// 0.0~1.0,默认为1.0
 self.audioPlayer.numberOfLoops = -1; // 循环播放
 }
 
 return self;
 }
 
 // 添加一个定时器，退到后台后会在10秒左右的时间停止运行程序，在每一段时间内(暂时设为5)应播放一次音乐。为了省电音乐应尽可能短。
 - (void)startRunInbackGround {
 // 调用audioStartPlay方法
 NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:5.0 target:self selector:@selector(startAudioPlay) userInfo:nil repeats:YES];
 // 如果不是主线程循环需要开启循环
 //    if ([NSRunLoop currentRunLoop] != [NSRunLoop mainRunLoop]) {
 //        [[NSRunLoop currentRunLoop] run];
 //    }
 // 默认
 [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
 self.audioTimer = timer;
 }
 
 - (void)startAudioPlay {
 // 异步执行
 [self.audioPlayer play];
 }
 
 - (void)stopAudioPlay {
 // 关闭定时器即可
 [self.audioTimer invalidate];
 // 保证释放
 self.audioTimer = nil;
 }
 
 - (void)setupAudioSession {
 // 新建AudioSession会话
 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
 // 设置后台播放
 NSError *error = nil;
 [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
 
 if (error) {
 
 NSLog(@"Error setCategory AVAudioSession: %@", error);
 }
 
 NSError *activeSetError = nil;
 // 启动AudioSession，如果一个前台app正在播放音频则可能启动失败
 [audioSession setActive:YES error:&activeSetError];
 
 if (activeSetError) {
 
 NSLog(@"Error activating AVAudioSession: %@", activeSetError);
 }
 }

 
 */



/* 使用方法
 分为5步：
 1 添加文件runInBg目录下的文件
 2 包含头文件  #import "JJRuninbackground.h"
 3 使用全局队列实现异步执行
 4 使用单利调用startRunInbackGround方法
 5 开启循环
 停止时调用[[RunInBackground sharedBg] stopAudioPlay];即可
 
 
 ********************************以下为具体例子***********************************
 在进入后台时可以调用startRunInbackGround方法
 - (void)applicationDidEnterBackground:(UIApplication *)application {
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 [[RunInBackground sharedBg] startRunInbackGround];
 [[NSRunLoop currentRunLoop] run];
 });
 }
 前台时停止播放
 - (void)applicationDidBecomeActive:(UIApplication *)application {
 [[RunInBackground sharedBg] stopAudioPlay];
 }
 */


@end
