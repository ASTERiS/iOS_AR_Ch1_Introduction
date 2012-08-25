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

int tempError;

// 탭 이름 설정.

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
    totalDist2 = 0.0f;    // 변수 초기화
    tempOldLocation = nil; //임시 과거 위치 기억 변수 초기화
    tempError = 0;
    
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
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}




#pragma mark Timer
//정기처리
-(void)onTick:(NSTimer*)timer
{
    
    // 속도 처리
    // 최고 속도 저장
    if (tempSpeed>=maxSpeed){
        maxSpeed = tempSpeed;
    }
        
    // 측정값 없을 때의 처리
    float tempSpeed3 = (tempSpeed+lastSpeed)/2;
    lastSpeed=tempSpeed3;
    if (tempSpeed<=0) {
        tempSpeed3 = 0.0f;   // 측정할 수 없을 땐 0 표시
    }
    
    // 000.0표시를 위해 실수 소수 분리, 및 자리 버림.
    infoSpeedView.text = [NSString stringWithFormat:@"%03d",(int)tempSpeed3]; //(큰 숫자) 소수점 전체 버리기 위해 int로 캐스팅
    double tempNum = tempSpeed3-(int)tempSpeed3;
    int tempNum2 = (int)(tempNum*10); //(작은 숫자) 소수점 두째 자리에서 버림을 위해 10을 곱하고 int로 캐스팅
    infoSpeedView2.text = [NSString stringWithFormat:@".%01d",tempNum2]; 
    
    //날짜 처리
    //날짜 콤포넌트 취득
    unsigned int unitFlag= NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    comps=[calendar components:unitFlag fromDate:[NSDate date]];
    // 날짜 표시
    dateView.text = [NSString stringWithFormat:@"%02d.%02d.    %02d:%02d.%02d ",comps.month,comps.day,comps.hour,comps.minute,comps.second];
    
}

#pragma mark GPS_Delegate

// 위치정보 델리게이트에 의한 호출

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"델리게이트 호출#1");

    
    //속도?
    tempSpeed = [newLocation speed]*3.6; // m/s를 km/h로 바꾸기 (60*60)/1000

    // 거리정보 취득 #1 델리게이트 호출 시 자동 계산 된 거리 계산.
    CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation];
    if (!(tempSpeed<=0.0)) { // 속도 측정할 수 없으면 거리 합산 하지 않는다.
        totalDist += abs(dist);
    }
    
    // 거리정보 취득 #2 기존 마지막 위치를 기준으로 새 거리 계산법
    
    if(!(tempSpeed<=0.0)){ //속도 측정할 수 없으면 거리 합산하지 않는다.
        NSLog(@"--------");
        NSLog(@"tempSpeed:%f",tempSpeed);
        if (tempOldLocation!=nil){ // 초기 위치값을 얻기 전까지는 더하지 않는다.
            NSLog(@"NEW    Location:%@",newLocation);
            NSLog(@"tempOldLocation:%@",tempOldLocation);
            if (!(oldLocation==tempOldLocation)) { //위치정보 차이 몇번이나 발생했나?
                tempError++;
            }
            CLLocationDistance dist2 = [newLocation distanceFromLocation:tempOldLocation];
            totalDist2 += abs(dist2);
        }
            tempOldLocation = newLocation; //현재 위치를 과거 위치로 기록 & 속도 측정할 수 없으면 바꾸지 않는다.
    }
    

    
    
    
    
    // 높이정보 사용가능여부 확인
    //높이용임시 변수
    /*
    double tempAltitude;
    
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
        gpsSignalView.text =[NSString stringWithFormat:@"No Signal : %6.2f",newLocation.horizontalAccuracy];
        gpsProgressView.progress = 0.0; // 그래프를 걍 0으로 처리.
    }
    else if (newLocation.horizontalAccuracy > 163.0)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"poor Signal : %6.2f",newLocation.horizontalAccuracy];
             // Poor Signal
            gpsProgressView.progress = (2-pow(1.004,newLocation.horizontalAccuracy-5.0));
            //5일 때 1, 대략 160근처에서 0이 나오는 지수함수.
    }
    else if (newLocation.horizontalAccuracy > 48.0)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Average Signal : %6.2f",newLocation.horizontalAccuracy]; // Average Signal
            gpsProgressView.progress = (2-pow(1.004,newLocation.horizontalAccuracy-5.0));
    }
    else
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Full Signal : %6.2f",newLocation.horizontalAccuracy];// Full Signal
        if (newLocation.horizontalAccuracy<=5) {
            gpsProgressView.progress = 1.0; //최대값은 5인듯하나 그보다 정확한 값이 나올 땐 그래프를 1로 처리.
        }
            gpsProgressView.progress = (2-pow(1.004,newLocation.horizontalAccuracy-5.0));
    }
    
    // 정보 표시 (정보 갱신 있는지 확인)
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];

    if (abs(howRecent) < 15.0)
    {
        infoTextView.text = [NSString stringWithFormat:@"위도 : %+6f\t경도 : %+6f\n높이 : %6.2f\t\t최고속 : %6.2fkm/h\n속도 : %6.2fm/s\t속도 : %6.2fkm/h\n총이동거리 : %08.3fkm\n총이동거리2 : %08.3fkm\n오차 : %dm\t\t\t오류 빈도 : %d\n필터 : %f",
                             newLocation.coordinate.latitude,//위도
                             newLocation.coordinate.longitude,//경도
                             newLocation.altitude, //tempAltitude
                             maxSpeed,
                             newLocation.speed,//속도
                             tempSpeed,
                             totalDist/1000,
                             totalDist2/1000,
                             abs(totalDist2-totalDist),
                             tempError,
                             self.locationManager.distanceFilter];
       
    }
    else
    {
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
    }
    else
    {
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
    self.locationManager.distanceFilter = kCLDistanceFilterNone;               // 필터?
//    self.locationManager.distanceFilter = 10;               // 필터?

    
    // 혹시 이전 주요 위치변화 정보 모니터링 기능이 켜져있다면 끄고 시작한다.
    if ([CLLocationManager  significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"주요 위치변화 정보 모니터링 기능 OFF");
		[self.locationManager startUpdatingLocation];
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

-(void)setFilter:(int)tempFilter
{
        self.locationManager.distanceFilter = tempFilter;
}







@end
