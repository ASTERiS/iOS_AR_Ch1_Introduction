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
@synthesize myArrayLabel;
@synthesize secTotalDistLabel;
@synthesize infoTextView;
@synthesize gpsSignalView;
@synthesize locationManager;

int tempError,tempError2;

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
    tempOldLocation2 = nil; //임시 과거 위치 기억 변수 초기화
    tempNewLocation2 = 0.0f;
    tempError = 0;
    tempError2 = 0;
    
    // 초분할 거리용 초기화
    secNewLocation=secOldLocation = nil;
    secTotalDist = 0.0f;
    secNum = 0;
    //첫실행 확인용 변수
    myFirstRun = 0;
    

    
    
    [self startLocationInit];    // 위치정보 초기화 호출
    

    //타이머 생성
    [NSTimer scheduledTimerWithTimeInterval:0.2f
                                     target:self
                                   selector:@selector(onTick:)
                                   userInfo:nil
                                    repeats:YES];

    
    //프리퍼런스 누적 거리 준비 만약 없다면 0을 기록하고 아니라면 패스
    pref = [NSUserDefaults standardUserDefaults];
    if (!([pref floatForKey:@"prefTotalDist"])) { // 값이 없으면 여기 실행
        prefTotalDist = 0.0f;
        [pref setFloat:prefTotalDist forKey:@"prefTotalDist"];
        [pref synchronize];
    }else{ //값이 있으면 읽기.
         prefTotalDist = [pref floatForKey:@"prefTotalDist"];
    }
    //NSdictionary
    secLocationArray =[NSMutableArray array];
    [secLocationArray addObject:@"start-location"];// 배열에 기록
    secDistanceArray =[NSMutableArray array];
    [secDistanceArray addObject:@"start-distance"];// 배열에 기록
    
 
    
}

- (void)viewDidUnload
{
    [self setInfoTextView:nil];
    [self setGpsSignalView:nil];
    [self setGpsProgressView:nil];
    [self setInfoSpeedView:nil];
    [self setDateView:nil];
    [self setInfoSpeedView2:nil];
    [self setMyArrayLabel:nil];
    [self setSecTotalDistLabel:nil];
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

    
    NSLog(@"secNum:%d",secNum);
    if (secNum ==4) // 5번째 (0.2*5 1초)일 때 거리정보 계산을 추가로 실행함.
    {
 
        
        // 프리퍼런스 값에서 읽어 전역변수에 대입
        
//        NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
        //총 누적 거리 갱신
        prefTotalDist = [pref floatForKey:@"prefTotalDist"];
        //필터값 갱신 및 적용
//        self.locationManager.distanceFilter =[pref floatForKey:@"prefFilter"];
        
        
        
        
        // 거리 계산
        
        if (secOldLocation==nil) // 첫실행으로 값이 없을 때의 초기화
        {
            secOldLocation = secNewLocation;
            [secDistanceArray addObject:@"0"];
            return;
        }
        
                
        [secLocationArray addObject:secNewLocation];// 위치 배열에 기록
        NSLog(@"위치정보 %@",secNewLocation);
        
        
        CLLocationDistance  secDist = [secNewLocation distanceFromLocation:secOldLocation]; // 거리 변화값 획득.
        if (secNewLocation.speed<0.0f||secNewLocation.horizontalAccuracy<0.0f) { // 만약 이동 속도를 구할 수 없다면 secDist(변화값)을 0으로 한다. -> 필터로 구현는 게 나을까?
            NSLog(@"horizontalAccuracy:%f",secNewLocation.horizontalAccuracy);
            secDist = 0.0f;
        }
        
        
        int tempIdx = [secDistanceArray count];  // 총 어레이 인덱스 값 구하기.
        NSLog(@"tempIdx %d",tempIdx);
        myArrayLabel.text=[NSString stringWithFormat:@"%d",tempIdx];
        
        NSString* secTempDist = [secDistanceArray objectAtIndex:tempIdx-1]; // 거리 배열의 이전값 (이전까지의 전체 거리)를 불러옴
        NSLog(@"secTempDist : %@",secTempDist);
        
        double secTempDistDouble = [secTempDist doubleValue]; // 배열값을 double형으로 형변환
        
        NSLog(@"secTempDistDouble : %f",secTempDistDouble);
        
        secTotalDist = secDist + secTempDistDouble; // 기존 거리값과 변화값을 더해줌
        
        secTotalDistLabel.text= [NSString stringWithFormat:@"이동거리 : %010.3f",secTotalDist/1000]; // 레이블에 표시
        NSLog(@"secTotalDist %f", secTotalDist);
        
        NSString* str = [NSString stringWithFormat:@"%f",secTotalDist];
        [secDistanceArray addObject:str];// 거리 배열에 현 누적거리 기록
        secOldLocation = secNewLocation; // 현제 위치정보를 이전 위치 정보로 기록함
        
 

        secNum = 0; // 타이머 0.2초 단위 계산 초기화 
    }
    
 
    // 속도 처리
    // 최고 속도 저장
    
    if (tempSpeed>=maxSpeed){
        maxSpeed = tempSpeed;
    }
    
    

    
    // 측정값 없을 때의 처리
    float tempSpeed3 = (tempSpeed+lastSpeed)/2;
    lastSpeed=tempSpeed3;
    if (tempSpeed<=0.0f) {
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

        
        secNum++; // 타이머 0.2초 단위 계산용 누적값. (0~3까지 else밑단 실행, 4에서 

   
}


#pragma mark GPS_Delegate

// 위치정보 델리게이트에 의한 호출

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    

    // 델리게이트 정보 취득 후 시간 흐름 체크
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    secNewLocation = newLocation;
    
    
    
    //
    NSLog(@"델리게이트 호출#1");
    tempError2++;
    tempNewLocation2=newLocation.coordinate.latitude *100.0f +newLocation.coordinate.longitude;
    
    //속도?
    tempSpeed = [newLocation speed]*3.6f; // m/s를 km/h로 바꾸기 (60*60)/1000

    
    if(!(tempSpeed<=0.0f)){ //속도 측정할 수 없거나 0이면 거리 합산하지 않는다.
//    if ((tempNewLocation2 - tempOldLocation3)!=0.000000) { // 위도값 변하면 동작
        NSLog(@"--------");
        NSLog(@"tempSpeed:%f",tempSpeed);
        if (tempOldLocation!=nil){ // 초기 위치값을 얻기 전까지는 더하지 않는다.
/*
            if (!(oldLocation==tempOldLocation)) { //위치정보 차이 몇번이나 발생했나?
                NSLog(@"NEW    Location:%@",newLocation);
                NSLog(@"tempOldLocation:%@",tempOldLocation);
                tempError++;  //에러발생 빈도 분자
            }
*/
            CLLocationDistance dist2 = [newLocation distanceFromLocation:tempOldLocation];
            totalDist2 += abs(dist2);
            
            // 현재 구한 거리를 누적 거리에 더하고 누적 거리를 프리퍼런스에 기록.
            prefTotalDist += abs(dist2);
            //
//            NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
            [pref setFloat:prefTotalDist forKey:@"prefTotalDist"];
            [pref synchronize];
            

        }
            tempOldLocation = newLocation; //현재 위치를 과거 위치로 기록 & 속도 측정할 수 없으면 바꾸지 않는다.
            tempOldLocation3 = newLocation.coordinate.latitude *100.0f +newLocation.coordinate.longitude;

    }
    

    
    // GPS 신호 정확성 체크
    
    if (newLocation.horizontalAccuracy < 0.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"No Signal : %6.2f",newLocation.horizontalAccuracy];
        gpsProgressView.progress = 0.0f; // 그래프를 걍 0으로 처리.
    }
    else if (newLocation.horizontalAccuracy > 163.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"poor Signal : %6.2f",newLocation.horizontalAccuracy];
             // Poor Signal
            gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
            //5일 때 1, 대략 160근처에서 0이 나오는 지수함수.
    }
    else if (newLocation.horizontalAccuracy > 48.0f)
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Average Signal : %6.2f",newLocation.horizontalAccuracy]; // Average Signal
            gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
    }
    else
    {
        gpsSignalView.text =[NSString stringWithFormat:@"Full Signal : %6.2f",newLocation.horizontalAccuracy];// Full Signal
        if (newLocation.horizontalAccuracy<=5) {
            gpsProgressView.progress = 1.0f; //최대값은 5인듯하나 그보다 정확한 값이 나올 땐 그래프를 1로 처리.
        }
            gpsProgressView.progress = (2.0f-pow(1.004f,newLocation.horizontalAccuracy-5.0f));
    }
    
    // 정보 표시 (정보 갱신 있는지 확인)


    if (abs(howRecent) < 15.0f)
    {
        infoTextView.text = [NSString stringWithFormat:@"위도 : %+6f\t경도 : %+6f\n높이 : %6.2f\t\t최고속 : %6.2fkm/h\n속도 : %6.2fm/s\t속도 : %6.2fkm/h\n이동거리2 : %08.3fkm\n누적이동거리 : %010.3fkm\n오차 : %dm\t빈도 :%d\n필터 : %f",
                             newLocation.coordinate.latitude,//위도
                             newLocation.coordinate.longitude,//경도
                             newLocation.altitude, //tempAltitude
                             maxSpeed,
                             newLocation.speed,//속도
                             tempSpeed,
                             totalDist2/1000,
                             prefTotalDist,
                             abs(totalDist2-totalDist),
                             tempError2,
                             self.locationManager.distanceFilter];
       
    }
    else
    {
        infoTextView.text =@"Update was old";
    }
    

    
}

#pragma mark Compass

// 방위정보 혼란시 교정용 화면 출력 <----???????? 동작 안 하는듯?????

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    NSLog(@"방위정보 교란");
    return YES;
}


#pragma mark GPS initialize

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

// 위치정보 취득 초기화




-(void)startLocationInit
{

    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;               // 필터?
    self.locationManager.distanceFilter = 1.0f;               // 필터? (미터단위)

    
    // 혹시 이전 주요 위치변화 정보 모니터링 기능이 켜져있다면 끄고 시작한다.
    if ([CLLocationManager  significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"주요 위치변화 정보 모니터링 기능 OFF");
		[self.locationManager startUpdatingLocation];
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




@end
