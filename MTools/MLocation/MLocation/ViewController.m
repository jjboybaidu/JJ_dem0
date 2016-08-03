//
//  ViewController.m
//  MLocation
//
//  Created by farbell-imac on 16/8/3.
//  Copyright © 2016年 farbell. All rights reserved.
//

#import "ViewController.h"
#import "JJCLLocation.h"

@interface ViewController ()
@property(nonatomic,weak)IBOutlet UITextView *locationTextView;

@end

@implementation ViewController{
    JJCLLocation *location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getLocation{
    [self setupLocation];
}

// setupLocationBackGround
- (void)setupLocation{
    location = [JJCLLocation sharedInstance];
    [location startUpdatingLocation];
    self.locationTextView.text = location.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
