//
//  ViewController.h
//  gpsDistance
//
//  Created by ASTERiS on 10/11/12.
//  Copyright (c) 2012 ASTERiS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager*  locationManager;
    CLLocationSpeed     tempSpeed, lastSpeed, maxSpeed, distSpeed;  //속도용
    UIProgressView*     gpsProgressView; //GPS 프로그래스바
    NSCalendar*         calendar;
    NSDateComponents*   comps;
    int                 myFirstRun;
    // 델리게이트 내 거리 처리용
    CLLocation*         delNewLocation;// 지금 위치를 기록
    CLLocation*         delOldLocation;// 이전 위치를 기록
    CLLocationDistance  delTotalDist; // 총거리
    CLLocationDistance  delTotalDist2; // 총거리
    CLLocationDistance  delTotalDist3; // 총거리
    //지도 관련
    MKMapView*          map;
    NSMutableArray*     secLocationArray;
    CLLocationCoordinate2D routeCoords[3600];
    int                 lastIdx;
}

@property (strong, nonatomic) IBOutlet UIProgressView *gpsProgressView;
@property (weak, nonatomic) IBOutlet UILabel *gpsSignalView;
@property (nonatomic, retain) CLLocationManager* locationManager; //
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

-(void)startLocationInit;
-(void)gpsIndicator:(CLLocation*)newLocation;

@end
