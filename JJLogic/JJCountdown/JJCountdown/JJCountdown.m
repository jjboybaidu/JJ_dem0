//
//  JJCountdown.m
//  JJCountdown
//
//  Created by farbell-imac on 16/7/14.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "JJCountdown.h"

@interface JJCountdown(){
    dispatch_source_t _timer;
}

@property (weak, nonatomic) UILabel *dayLabel;
@property (weak, nonatomic) UILabel *hourLabel;
@property (weak, nonatomic) UILabel *minuteLabel;
@property (weak, nonatomic) UILabel *secondLabel;

@end

@implementation JJCountdown

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupJJCountdown];
}

- (NSString*)getCurrentTime{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

// setupJJCountdown
- (void)setupJJCountdown{
    UILabel *daylabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 300, 30, 30)];
    [daylabel setFont:[UIFont systemFontOfSize:20]];
    self.dayLabel = daylabel;
    [self.view addSubview:daylabel];
    
    UILabel *hourlabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 300, 30, 30)];
    [hourlabel setFont:[UIFont systemFontOfSize:20]];
    self.hourLabel = hourlabel;
    [self.view addSubview:hourlabel];
    
    UILabel *minutelabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 300, 30, 30)];
    [minutelabel setFont:[UIFont systemFontOfSize:20]];
    self.minuteLabel = minutelabel;
    [self.view addSubview:minutelabel];
    
    UILabel *secondlabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 300, 30, 30)];
    [secondlabel setFont:[UIFont systemFontOfSize:20]];
    self.secondLabel = secondlabel;
    [self.view addSubview:secondlabel];
    
    [self readyCountdown];
}

- (void)readyCountdown{
    // endTIme
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:[self getCurrentTime]];
    // 这里设置截止时间
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 2*24*3600)];
    // startTime
    NSDate *startDate = [NSDate date];
    // theMinus of endTime and startTime
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间,当前时间与结束时间差值
        
        if (timeout!=0) {
            // Thread
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        self.dayLabel.text = @"";
                    }
                    
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            self.dayLabel.text = @"0天";
                        }else{
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        
                        if (hours<10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        
                        if (minute<10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        
                        if (second<10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

@end
