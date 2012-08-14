//
//  AppDelegate.h
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
//@interface iOS_AR_Ch3_LocationServicesAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
