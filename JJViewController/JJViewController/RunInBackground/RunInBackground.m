
#import "RunInBackground.h"
#import <AVFoundation/AVFoundation.h>

@interface RunInBackground ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSTimer *audioTimer;

@end

@implementation RunInBackground

+ (instancetype)sharedBg {
    static dispatch_once_t onceToken;
    static id instance;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setUpAudioSession];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mysong" ofType:@"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.volume = 0.01;// 0.0~1.0,默认为1.0
        self.audioPlayer.numberOfLoops = -1;// 循环播放
    }
    
    return self;
}

- (void)setUpAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&error];
    
    if (error) {
        
        NSLog(@"Error setCategory AVAudioSession: %@", error);
    }
    
    NSError *activeSetError = nil;
    [audioSession setActive:YES error:&activeSetError];
    
    if (activeSetError) {
        
        NSLog(@"Error activating AVAudioSession: %@", activeSetError);
    }
}

- (void)startRunInbackGround {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                              interval:5.0
                                                target:self
                                              selector:@selector(startAudioPlay)
                                              userInfo:nil
                                               repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.audioTimer = timer;
}

- (void)startAudioPlay {
    [self.audioPlayer play];// 异步执行
}

- (void)stopAudioPlay {
    [self.audioTimer invalidate];
    self.audioTimer = nil;
}
@end


