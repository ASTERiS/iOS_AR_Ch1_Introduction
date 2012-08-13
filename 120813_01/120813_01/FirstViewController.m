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
@synthesize myImageView;
@synthesize locationTextView; 
@synthesize headingTextView;



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

    [super viewDidLoad];
    [self startStandardUpdates];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    [self setMyImageView:nil];
    [self startSignificantChangeUpdates];
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
    
    locationTextView.text = [NSString stringWithFormat:@"위도:%+.6f\n경도:%+.6f\n",
                             newLocation.coordinate.latitude,
                             newLocation.coordinate.longitude];
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
    [locationManager startMonitoringSignificantLocationChanges];
}




@end
