//
//  AppDelegate.m
//  JJViewController
//
//  Created by farbell-imac on 16/7/8.
//  Copyright © 2016年 jjboybaidu. All rights reserved.
//

#import "AppDelegate.h"
#import "RunInBackground.h"
#import "JJNewFeature.h"
#import "JJTableViewRowAction.h"
#import "JJCountdown.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Setup New Feature
    // [self setupNewFeature];
    
    // Setup JJTableViewRowAction
    // [self setupJJTableViewRowAction];
    
    // setup JJCountdown
    // [self setupJJCountdown];
    
    return YES;
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
    nav.navigationBar.backgroundColor=[UIColor blackColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[RunInBackground sharedBg] startRunInbackGround];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[RunInBackground sharedBg] stopAudioPlay];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
