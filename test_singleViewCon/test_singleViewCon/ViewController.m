//
//  ViewController.m
//  test_singleViewCon
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
    [locationManager startMonitoringSignificantLocationChanges];
    
}

- (void)viewDidUnload
{
    [self setLocText:nil];
    [locationManager stopMonitoringSignificantLocationChanges];
    locationManager = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    [locationManager stopUpdatingLocation];
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


@end
