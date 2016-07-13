
#import <Foundation/Foundation.h>

@interface RunInBackground : NSObject

+ (instancetype)sharedBg;

- (void)startRunInbackGround;// 开始进入后台

- (void)stopAudioPlay;// 停止播放音乐

@end
