//
//  FirstViewController.m
//  astBikeDash
//
//  Created by Administrator on 8/16/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize gpsProgressView;
@synthesize infoSpeedView;
@synthesize dateView;
@synthesize infoSpeedView2;
@synthesize infoTextView;
@synthesize gpsSignalView;
@synthesize locationManager;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}



							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    totalDist = 0.0f;    // 변수 초기화
    
    [self startLocationInit];    // 위치정보 초기화 호출

    //타이머 생성
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];
    
    

}

- (void)viewDidUnload
{
    [self setInfoTextView:nil];
    [self setGpsSignalView:nil];
    [self setGpsProgressView:nil];
    [self setInfoSpeedView:nil];
    [self setDateView:nil];
    [self setInfoSpeedView2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Timer
//정기처리
-(void)onTick:(NSTimer*)timer
{
    
    // 속도 처리
    if (tempSpeed>=maxSpeed){
        maxSpeed = tempSpeed;
    }
        
    
    
    float tempSpeed3 = (tempSpeed+lastSpeed)/2;
    lastSpeed=tempSpeed3;
    if (tempSpeed<=0) {
        tempSpeed3 = 0.0f;
    }
    
    infoSpeedView.text = [NSString stringWithFormat:@"%03.0f",tempSpeed3]; // 큰 숫자 표시
    
    double tempNum;  // 소수점 구하기
    tempNum = modf(tempSpeed3, &tempNum);
    infoSpeedView2.text = [NSString stringWithFormat:@".%02.0f",tempNum*100]; // 작은 숫자 표시 소수점*100 
    
    //날짜 처리
    
    //날짜 콤포넌트 취득
    unsigned int unitFlag= NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    comps=[calendar components:unitFlag fromDate:[NSDate date]];
    dateView.text = [NSString stringWithFormat:@"%02d.%02d.    %02d:%02d.%02d ",comps.month,comps.day,comps.hour,comps.minute,comps.second];
    
}

#pragma mark GPS_Delegate

// 위치정보 델리게이트에 의한 호출

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"델리게이트 호출#1");
    
    //속도?
    tempSpeed = [newLocation speed]*3.6; // m/s를 km/h로 바꾸기 (60*60)/1000
    // 거리정보 취득
    CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation];
    totalDist += abs(dist);

    
    // 높이정보 사용가능여부 확인
    //높이용임시 변수


    /*
    float tempAltitude;
    
    if (signbit(newLocation.verticalAccuracy)) {
        NSLog(@"높이정보 사용가능");
        tempAltitude = newLocation.altitude;
        
    } else {
        NSLog(@"높이정보 사용불능");
        tempAltitude = 0.0f;
        
    }
   */

    
    // GPS 신호 정확성 체크
    
    if (newLocation.horizontalAccuracy < 0.0)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"No Signal : %6f",newLocation.horizontalAccuracy];
        gpsProgressView.progress = (1.0-((abs(newLocation.horizontalAccuracy))+1.0)/200.0);
        
    }
    else if (newLocation.horizontalAccuracy > 163.0)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"poor Signal : %6f",newLocation.horizontalAccuracy];
             // Poor Signal
        gpsProgressView.progress = (1.0-((abs(newLocation.horizontalAccuracy))+1.0)/200.0);
    }
    else if (newLocation.horizontalAccuracy > 48.0)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Average Signal : %6f",newLocation.horizontalAccuracy];
 // Average Signal
        gpsProgressView.progress = (1.0-((abs(newLocation.horizontalAccuracy))+1.0)/200.0);
    }
    else
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Full Signal : %6f",newLocation.horizontalAccuracy];
;// Full Signal
        gpsProgressView.progress = (1.0-((abs(newLocation.horizontalAccuracy))+1.0)/200.0);
    }
    
    
    
    
    
    
    
    // 정보 표시 (정보 갱신 있는지 확인)
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        infoTextView.text = [NSString stringWithFormat:@"위도 : %+6f\t경도 : %+6f\n높이 : %6.2f\t\t최고속 : %6.2fkm/h\n속도 : %6.2fm/s\t속도 : %6.2fkm/h\n총이동거리 : %010.1fm\n",
                             newLocation.coordinate.latitude,//위도
                             newLocation.coordinate.longitude,//경도
                             newLocation.altitude, //tempAltitude
                             maxSpeed,
                             newLocation.speed,//속도
                             tempSpeed,
                             totalDist];
       
    }else{
        infoTextView.text =@"Update was old";
    }
    
    
    
}

// 위치정보 취득에 관련된 허가 유무

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
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"위치정보 취득 실패."
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"위치정보 취득 실패");
    }
}

// 위치정보 취득 초기화
-(void)startLocationInit
{

    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1;               // 필터?

    
    // 혹시 이전 주요 위치변화 정보 모니터링 기능이 켜져있다면 끄고 시작한다.
    
    if ([CLLocationManager  significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"주요 위치변화 정보 모니터링 기능 OFF");
		[self.locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
    
    //날짜 정보 초기화
    calendar= nil;
    comps = nil;
    // 오브젝트 대입
    calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];

    
}



@end
