//
//  FirstViewController.h
//  astBikeDash
//
//  Created by Administrator on 8/16/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKMapView.h>




@interface FirstViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager*  locationManager;
    UITextView*         infoTextView;
    float               totalDist;  //총거리 합산용
    float               totalDist2;  //총거리 합산용 2
    float               totalDist3; 
    float               prefTotalDist; //총거리 프리퍼런스 기록용
    CLLocationSpeed     tempSpeed, lastSpeed, maxSpeed, distSpeed;  //속도용
    UIProgressView*     gpsProgressView; //GPS 프로그래스바
    NSCalendar*         calendar;
    NSDateComponents*   comps;
    CLLocation*         tempOldLocation;
    CLLocation*         tempOldLocation2;
    double        tempOldLocation3;
    double        tempNewLocation2;
    NSMutableArray* myArray;
    // 첫실행 확인
    int                 myFirstRun;
    NSTimeInterval      appTimer;
    // 초분할 관련
    int                 secNum; // 0.2초 단위 계산용.
    CLLocation*         secNewLocation;// 지금 위치를 기록
    CLLocation*         secOldLocation;// 이전 위치를 기록
    NSMutableArray*     secLocationArray; // 위치 저장용 배열
    NSMutableArray*     secDistanceArray; // 거리 저장용 배열
    double              secTotalDist; // 총거리

    
    NSUserDefaults*     pref; // 프리퍼런스 억세스용
    
        CLLocationDistance  totalDistButton; // 변수내 값 확인용 총거리
    
}


@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UITextView *gpsSignalView;
@property (nonatomic, retain) CLLocationManager* locationManager; //
@property (strong, nonatomic) IBOutlet UIView *gpsProgressView;
@property (strong, nonatomic) IBOutlet UILabel *infoSpeedView;
@property (weak, nonatomic) IBOutlet UILabel *dateView;
@property (weak, nonatomic) IBOutlet UILabel *infoSpeedView2;

@property (weak, nonatomic) IBOutlet UILabel *myArrayLabel;
@property (strong, nonatomic) IBOutlet UILabel *secTotalDistLabel;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;

@property (weak, nonatomic) IBOutlet UILabel *gpsTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkButton;

- (IBAction)totalDistButton:(id)sender;


- (IBAction)myMapViewModalButton;


-(void)startLocationInit; // 위치정보 취득 초기화





@end
