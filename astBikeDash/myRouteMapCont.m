//
//  myRouteMapCont.m
//  astBikeDash
//
//  Created by Administrator on 9/11/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "myRouteMapCont.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKUserLocation.h>
#import <CoreLocation/CLLocation.h>
#import "FirstViewController.h"

@interface myRouteMapCont ()

@end

@implementation myRouteMapCont
@synthesize myMapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [myMapView setShowsUserLocation:YES];
    
    
    
    //타이머 생성
    [NSTimer scheduledTimerWithTimeInterval:1.f
                                     target:self
                                   selector:@selector(onMapTick:)
                                   userInfo:nil
                                    repeats:YES];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [self setMyMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)onMapTick:(NSTimer*)timer
{
    MKCoordinateRegion region;
    MKCoordinateSpan    span;
    
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;

    region.center = myMapView.userLocation.coordinate;

    region.span = span;
    [myMapView setRegion:region animated:YES];
    [myMapView regionThatFits:region];
    [myMapView setCenterCoordinate:region.center animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeModal {
    [self dismissModalViewControllerAnimated:YES];
}
@end
