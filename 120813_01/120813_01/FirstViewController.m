//
//  FirstViewController.m
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
//#import <CoreLocation/CoreLocation.h>

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize locationTextView; 




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

    locationTextView.text = @"TEST";
//    [self startStandardUpdates];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500;
    locationTextView.text = @"TEST3";
    [locationManager startUpdatingLocation];
    locationTextView.text = @"TEST4";
    
    if([CLLocationManager locationServicesEnabled]){
        locationTextView.text =@"위치정보서비스 활성화 성공";
        [locationManager startUpdatingLocation];
    } else {
        locationTextView.text = @"위치정보서비스 활성화 실패";
    }

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    locationTextView.text = @"TEST2";
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) <15.0)
    {
    
    locationTextView.text = [NSString stringWithFormat:@"latitude %+.6f, longitude %+.6f\n", 
                             newLocation.coordinate.latitude,
                             newLocation.coordinate.longitude];
    }else {
        locationTextView.text = @"Update was old";
    }
}
/*
-(void)startStandardUpdates
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500;
    locationTextView.text = @"TEST3";
    [locationManager startUpdatingLocation];
    locationTextView.text = @"TEST4";
    
    if([CLLocationManager locationServicesEnabled]){
        locationTextView.text =@"위치정보서비스 활성화 성공";
        [locationManager startUpdatingLocation];
    } else {
        locationTextView.text = @"위치정보서비스 활성화 실패";
    }
}
*/

@end
