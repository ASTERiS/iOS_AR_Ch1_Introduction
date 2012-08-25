//
//  AppDelegate.m
//  astBikeDash
//
//  Created by Administrator on 8/16/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation AppDelegate
@synthesize firstViewController; // 추가


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; // 화면 잠김으로 들어가지 않게 함.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.




}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
        NSLog(@"1.%@",firstViewController.locationManager);
        [firstViewController.locationManager stopUpdatingLocation];
        NSLog(@"백그라운드 진입");
		[firstViewController.locationManager startMonitoringSignificantLocationChanges];
        
        NSLog(@"2.%@",firstViewController.locationManager);
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO]; // 화면 잠김세팅 풀기
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}


}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 
    //백그라운드 진입시 주요 위치변화 정보 모니터링이 가능하다면 그것을 켜고 위치정보 취득방법을 전환한다.
    //단 현재 버전(Xcode 4.4) iOS 5.1에서는 주요 위치변화 정보 모니터링 기능 사용시 강제 종료되면 GPS인디케이터(화살표)가 사라지지 않는다.
    //
    
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[firstViewController.locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"활성화");
		[firstViewController.locationManager startUpdatingLocation];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
