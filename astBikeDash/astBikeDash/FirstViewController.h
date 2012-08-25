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
    float               totalDist2;  //총거리 합산용 2
    float               prefTotalDist; //총거리 프리퍼런스 기록용
    CLLocationSpeed     tempSpeed, lastSpeed, maxSpeed;  //속도용
    UIProgressView*     gpsProgressView; //GPS 프로그래스바
    NSCalendar*         calendar;
    NSDateComponents*   comps;
    CLLocation*         tempOldLocation;

    
}


@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UITextView *gpsSignalView;
@property (nonatomic, retain) CLLocationManager* locationManager; //
@property (strong, nonatomic) IBOutlet UIView *gpsProgressView;
@property (strong, nonatomic) IBOutlet UILabel *infoSpeedView;
@property (weak, nonatomic) IBOutlet UILabel *dateView;
@property (weak, nonatomic) IBOutlet UILabel *infoSpeedView2;

- (IBAction)tempReset;


-(void)startLocationInit; // 위치정보 취득 초기화
-(void)setFilter:(int)tempFilter;




@end
