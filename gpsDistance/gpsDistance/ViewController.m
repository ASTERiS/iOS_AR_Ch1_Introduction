//
//  ViewController.m
//  gpsDistance
//
//  Created by ASTERiS on 10/11/12.
//  Copyright (c) 2012 ASTERiS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize gpsProgressView;
@synthesize gpsSignalView;
@synthesize infoTextView;
@synthesize locationManager;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    myFirstRun = 0;
    lastIdx = 0;
    [self startLocationInit];
    

    
    MKCoordinateRegion  region;
    MKCoordinateSpan    span;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    bounds.origin.y+= 140;
    bounds.size.height-=140;
    
    
    map = [[MKMapView alloc]initWithFrame:bounds];
    map.mapType = MKMapTypeStandard;
    map.showsUserLocation = YES;
    
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    region.center = CLLocationCoordinate2DMake(37.564123, 126.974702);
    region.span = span;
    [map setRegion:region animated:YES];
    [map setCenterCoordinate:region.center animated:YES];
    [map regionThatFits:region];
    
    
    [self.view addSubview:map];
    
    
    map.delegate = self;

    
    
    secLocationArray =[NSMutableArray array];
    [secLocationArray addObject:@"start-location"];// 배열에 기록
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startLocationInit
{
    
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    locationManager.distanceFilter = kCLDistanceFilterNone;               // 필터?
    //    self.locationManager.distanceFilter = 1.0f;               // 필터? (미터단위)
    
    
    // 혹시 이전 주요 위치변화 정보 모니터링 기능이 켜져있다면 끄고 시작한다.
    if ([CLLocationManager  significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"주요 위치변화 정보 모니터링 기능 OFF");
		[locationManager startUpdatingLocation];
        //   		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	else
    {
		NSLog(@"Significant location change monitoring is not available.");
	}
    
    //날짜 정보 초기화
    calendar= nil;
    comps = nil;
    // 오브젝트 대입
    calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    
}

-(void)gpsIndicator:(CLLocation*)newLocation // GPS 상태 게이지 바 처리 루틴
{
    if (newLocation.horizontalAccuracy < 0.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"No Signal : %6.2f",newLocation.horizontalAccuracy];
        gpsProgressView.progress = 0.0f; // 그래프를 걍 0으로 처리.
    }
    else if (newLocation.horizontalAccuracy > 163.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"poor Signal : %6.2f",newLocation.horizontalAccuracy];
        // Poor Signal
        gpsProgressView.progressTintColor=[UIColor redColor];
        gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
        //5일 때 1, 대략 160근처에서 0이 나오는 지수함수.

    }
    else if (newLocation.horizontalAccuracy > 48.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Average Signal : %6.2f",newLocation.horizontalAccuracy]; // Average Signal
        gpsProgressView.progressTintColor=[UIColor yellowColor];
        gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
        
    }
    else
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Full Signal : %6.2f",newLocation.horizontalAccuracy];// Full Signal
        gpsProgressView.progressTintColor=[UIColor blueColor];
        if (newLocation.horizontalAccuracy<=5) {
            gpsProgressView.progress = 1.0f; //최대값은 5인듯하나 그보다 정확한 값이 나올 땐 그래프를 1로 처리.

        }
        gpsProgressView.progressTintColor=[UIColor greenColor];
        gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
                
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
     [secLocationArray addObject:newLocation];
    

    routeCoords[lastIdx] = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    lastIdx++;
    
 //   NSLog(@"델리게이트 호출#1");
    // 델리게이트 정보 취득 후 시간 흐름 체크
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    //속도 : 초속에서 시속으로
    //    tempSpeed = [newLocation speed]*3.6f; // m/s를 km/h로 바꾸기 (60*60)/1000
    tempSpeed = newLocation.speed*3.6f;
    
    
    
    
    // GPS 신호 정확성 체크
    [self gpsIndicator:newLocation];
    
    //델리게이트 값에 근거한 거리 계산
    if (myFirstRun == 0)
    {
        delOldLocation = newLocation;
        myFirstRun ++;
    }
    
    CLLocationDistance  delDist = abs([newLocation distanceFromLocation:delOldLocation]); // 거리 변화값 획득.
    delTotalDist +=delDist;
    delOldLocation = newLocation;
    

     if (abs(howRecent) < 15.0f)
     {
     infoTextView.text = [NSString stringWithFormat:@"위도 : %+6f\t경도 : %+6f\n높이 : %6.2f\t\t최고속 : %6.2fkm/h\n속도 : %6.2fm/s\t속도 : %6.2fkm/h\n델누적거리 : %010.3fm\n필터 : %f",
     newLocation.coordinate.latitude,//위도
     newLocation.coordinate.longitude,//경도
     newLocation.altitude, //tempAltitude
     maxSpeed,
     newLocation.speed,//속도
     tempSpeed,
     delTotalDist/1000,
     self.locationManager.distanceFilter];
     
     }
     else
     {
     infoTextView.text =@"Update was old";


    
}
         [map setCenterCoordinate:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude) animated:YES];
    
        [self createRoute];
/*

*/
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"위치정보 취득은 허가되어있지 않습니다."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        
        NSLog(@"위치정보취득은 허가되어있지 않음");
    }
    else
    { // 이 부분은 얼럿창이 아니라 다른 것으로 바꿔야할지도? ----------------------------------------------------------------------------
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"위치정보 취득 실패."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"위치정보 취득 실패:%@",error);
    }
}

-(void)createRoute
{

    int pointCount = [secLocationArray count];

    NSLog(@"포인트 카운트 %d",pointCount);
    


    
    
    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:(CLLocationCoordinate2D*)routeCoords count:pointCount-1];
    [map addOverlay:routeLine];
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    MKPolylineView *plView = [[MKPolylineView alloc] initWithOverlay:overlay];
    plView.strokeColor = [UIColor redColor];
    plView.lineWidth = 5.0;
 
    return plView;
    
}


@end