//
//  AppDelegate.m
//  JJViewController
//
//  Created by farbell-imac on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "AppDelegate.h"
#import "JJNewFeature.h"
#import "JJTableViewRowAction.h"
#import "JJCountdown.h"
#import "JJAlertController.h"
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "JJRuninbackground.h"
#import "JJCLLocation.h"
#import "JJDelegateAviewController.h"
#import "JJScanner.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    NSTimer *timer;
    JJCLLocation *location;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Setup New Feature
    // [self setupNewFeature];
    
    // Setup JJTableViewRowAction
    // [self setupJJTableViewRowAction];
    
    // setup JJCountdown
    // [self setupJJCountdown];
    
    // setupJJCLLocation
    // [self setupJJCLLocation];
    
    // setupJJDelegateBviewController
    // [self setupJJDelegateBviewController];
    
    // setupJJScannerViewController
    [self setupJJScannerViewController];
    
    return YES;
}

// setupJJScannerViewController
- (void)setupJJScannerViewController{
    JJScanner *scannerViewController = [[JJScanner alloc]init];
    // scannerViewController.view.backgroundColor = [UIColor grayColor];
    // [scannerViewController startScan];
    self.window.rootViewController = scannerViewController;
}

// setupJJDelegateBviewController
- (void)setupJJDelegateBviewController{
    JJDelegateAviewController *aViewController = [[JJDelegateAviewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

// setupJJCLLocation
- (void)setupJJCLLocation{
    location = [[JJCLLocation alloc]init];
    [location setupJJCLLocationManager];
}

// setupJJCountdown
- (void)setupJJCountdown{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    JJCountdown *countdown = [[JJCountdown alloc]init];
    countdown.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = countdown;
    [self.window makeKeyAndVisible];
}

// Setup NewFeature
- (void)setupNewFeature{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    JJNewFeature *newfeature = [[JJNewFeature alloc]init];
    self.window.rootViewController = newfeature;
    [self.window makeKeyAndVisible];
}

// Setup JJTableViewRowAction
- (void)setupJJTableViewRowAction{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    JJTableViewRowAction *tableviewrowaction = [[JJTableViewRowAction alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:tableviewrowaction];
    nav.navigationBar.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
     UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:notification.alertBody message:notification.alertBody delegate:self cancelButtonTitle:@"submit" otherButtonTitles:nil];
     [alertview show];
    
    [self performSelector:@selector(setupDismissView:) withObject:alertview afterDelay:0.001];
}

// setup dismissView
- (void)setupDismissView:(UIAlertView*)alertview{
    [alertview dismissWithClickedButtonIndex:0 animated:NO];
    alertview = NULL;
}

// setup JJAlertController
- (void)setupJJAlertController{
    JJAlertController *alertController = [[JJAlertController alloc]init];
    ViewController *viewcontroller = [[ViewController alloc]init];
    [viewcontroller presentViewController:[alertController setupAlertController] animated:YES completion:^{     }];
}

// setup ViewController
- (void)setupViewController{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    //运行后台模式方式选择
    // [self runInBackgroundMode2];
    // NSLog(@"[AppDelegate] 程序进入后台运行！");
}
- (void)runInBackgroundMode1{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[JJRuninbackground sharedInstance] startRunInbackGround];
        [[NSRunLoop currentRunLoop] run];
    });
}
- (void)runInBackgroundMode2{
    [location enterBackGround];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // [[JJRuninbackground sharedInstance] stopAudioPlay];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
