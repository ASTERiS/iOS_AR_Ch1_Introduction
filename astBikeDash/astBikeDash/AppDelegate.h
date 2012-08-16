//
//  AppDelegate.h
//  astBikeDash
//
//  Created by Administrator on 8/16/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FirstViewController; // @class명령은 필요한 클래스를 사용한다고 선언. 중복 가능. Objectiv-C p.123

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) FirstViewController *firstViewController; // 추가


@end
