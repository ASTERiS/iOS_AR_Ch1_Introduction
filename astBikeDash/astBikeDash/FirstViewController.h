//
//  FirstViewController.h
//  astBikeDash
//
//  Created by Administrator on 8/16/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FirstViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager*  locationManager;
    UITextView*         infoTextView;
    float               totalDist;  //총거리 합산용
    CLLocationSpeed     tempSpeed, lastSpeed, maxSpeed;  //속도용
    UIProgressView*     gpsProgressView; //GPS 프로그래스바
    
}


@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UITextView *gpsSignalView;
@property (nonatomic, retain) CLLocationManager* locationManager; //
@property (strong, nonatomic) IBOutlet UIView *gpsProgressView;
@property (strong, nonatomic) IBOutlet UILabel *infoSpeedView;




-(void)startLocationInit; // 위치정보 취득 초기화

@end