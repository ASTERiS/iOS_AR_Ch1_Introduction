//
//  ViewController.m
//  test_singleViewCon_woARC
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locText;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationManager=[[CLLocationManager alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate=self;
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //    locationManager.distanceFilter = 10;
    [locationManager startUpdatingLocation];
}
-(void)dealloc
{
    [locationManager stopMonitoringSignificantLocationChanges];
    locationManager = nil;
    [locationManager release];
    [locText release];
    [locText release];
    [super dealloc];
    
}

- (void)viewDidUnload
{
    [self setLocText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setLocText:nil];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"델리게이트 호출#1");
    locText.text = [NSString stringWithFormat:@"위도:%+6f\n경도:%+6f\n",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied)
    {
        NSLog(@"위치정보취득은 허가되어있지 않음");
    }else{
        NSLog(@"위치정보 취득 실패");
    }
}

- (IBAction)resetLoc {
    [locationManager stopMonitoringSignificantLocationChanges];
    locationManager = nil;
    
    
    
}
@end
