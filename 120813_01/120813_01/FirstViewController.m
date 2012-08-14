//
//  FirstViewController.m
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
//#import <CoreLocation/CoreLocation.h>


//@interface FirstViewController ()
//@end

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
    [self startStandardUpdates];
    //[self startSignificantChangeUpdates];
    
    if ([CLLocationManager regionMonitoringAvailable]) {
        //        [self startRegionMonitoring];
    }
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    [self setMyImageView:nil];
    

 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return NO;
    }
}



- (void)startStandardUpdates
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 500;
    
    [locationManager startUpdatingLocation];
}

- (void)startRegionMonitoring
{
    NSLog(@"Starting region monitoring");
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.787359, -122.408227);
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coord radius:1000.0 identifier:@"San Francisco"];
    
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyKilometer];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert"
                                                    message:@"You entered the region"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
//    [alert release];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Alert"
                                                    message:@"You exited the region"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
//    [alert release];
}


// use significant-change location service
- (void)startSignificantChangeUpdates
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        locationTextView.text = [NSString stringWithFormat:@"latitude %+.6f, longitude %+.6f\n",
                                 newLocation.coordinate.latitude,
                                 newLocation.coordinate.longitude];
        
        //        CLLocationDistance dist = [newLocation distanceFromLocation:oldLocation] / 1000;
        //        locationTextView.text = [NSString stringWithFormat:@"distance %5.1f traveled"];
        
    } else {
        locationTextView.text = @"Update was old";
        // you'd probably just do nothing here and ignore the event
    }
    
    
    //    locationTextView.text = [NSString stringWithFormat:@"%6.2f m. ", newLocation.altitude];
}

@end
