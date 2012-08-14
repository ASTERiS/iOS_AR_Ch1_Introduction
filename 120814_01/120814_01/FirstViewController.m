//
//  FirstViewController.m
//  120814_01
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize myImageView;

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
    //    [self startStandardUpdates];
  //  [self startSignificantChangeUpdates];
    
    /*
     if ([CLLocationManager regionMonitoringAvailable]) {
     [self startRegionMonitoring];
     }
     */
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)dealloc
{
    [locationManager stopUpdatingHeading];
    [locationManager stopMonitoringForRegion:region];
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
    
    [locationManager release];
    locationManager = nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    locationTextView.text = @"TEST2";
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) <15.0)
    {
        
        CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation]/1000;
        locationTextView.text = [NSString stringWithFormat:@"위도:%+.6f\n경도:%+.6f\n거리:%5.1f 이동",
                                 newLocation.coordinate.latitude,
                                 newLocation.coordinate.longitude,
                                 dist];
    }else {
        locationTextView.text = @"Update was old";
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSDate* eventDate = newHeading.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) <15.0)
    {
        
        headingTextView.text =[NSString stringWithFormat:@"방위:%+3.2f\n",newHeading.trueHeading];
        myImageView.transform = CGAffineTransformMakeRotation(-(newHeading.trueHeading)*(M_PI/180));
        //        myImageView.transform = CGAffineTransformMakeRotation(180*(M_PI/(newHeading.trueHeading)));
        [UIView commitAnimations];
        
    }else {
        headingTextView.text = @"Update was old";
    }
    
}


-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"지역 진입");
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"지역 경보"
                                                   message:@"지역 안에 들어왔음"
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
/*
 -(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
 {
 NSLog(@"지역벗어남");
 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"지역 경보"
 message:@"지역을 벗어났음"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil, nil];
 [alert show];
 [alert release];
 }
 */
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"지역 벗어남");
}


-(void)startStandardUpdates
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500;
    [locationManager startUpdatingLocation];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
    }
    
    if ([CLLocationManager headingAvailable]) {
        [locationManager startUpdatingHeading];
    }
    [UIView beginAnimations:@"anime0" context:NULL];
    [UIView setAnimationRepeatCount:0];
    
    
    
    
    
}


-(void)startSignificantChangeUpdates
{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 500;
    
    [locationManager startMonitoringSignificantLocationChanges];
    [UIView beginAnimations:@"anime0" context:NULL];
    [UIView setAnimationRepeatCount:0];
    if ([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
    }
    
    if ([CLLocationManager headingAvailable]) {
        [locationManager startUpdatingHeading];
    }
}

-(void)startRegionMonitoring
{
    NSLog(@"리전 모니터링 시작");
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.787359, -122.408227);
    region = [[CLRegion alloc]initCircularRegionWithCenter:coord radius:100.0 identifier:@"San Francisco"];
    
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyKilometer];
}


@end
