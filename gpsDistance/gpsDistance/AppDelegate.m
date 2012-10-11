//
//  AppDelegate.m
//  gpsDistance
//
//  Created by ASTERiS on 10/11/12.
//  Copyright (c) 2012 ASTERiS. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
        NSLog(@"1.%@",viewController.locationManager);
        [viewController.locationManager stopUpdatingLocation];
        NSLog(@"백그라운드 진입");
		[viewController.locationManager startMonitoringSignificantLocationChanges];
        
        NSLog(@"2.%@",viewController.locationManager);
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO]; // 화면 잠김세팅 풀기
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[viewController.locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"활성화");
		[viewController.locationManager startUpdatingLocation];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; // 화면 잠김으로 들어가지 않게 함.
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
