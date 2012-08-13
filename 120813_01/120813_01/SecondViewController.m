//
//  SecondViewController.m
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

-(void)showAlert:(NSString*)title text:(NSString*)text
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
    [alert show];
}

-(void)resizeLabel:(UILabel*)label
{
    CGRect frame = label.frame;
    frame.size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(512, 512) lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:frame];
}

-(UILabel*)makeLabel:(CGPoint)pos text:(NSString*)text font:(UIFont*)font
{
    UILabel* label = [[UILabel alloc]init];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self resizeLabel:label];
    return label;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    _label=[self makeLabel:CGPointMake(0, 0) text:@"LocationEX" font:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_label];
    
    
    _latitude = 0;
    _longitude = 0;
    _heading = 0;
    
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate = self;
/*
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
    }
    
    if ([CLLocationManager headingAvailable]) {
        [_locationManager startUpdatingHeading];
    }
*/    
//    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)onTick:(NSTimer*)timer
{
    NSMutableString* str = [NSMutableString string];
    //[str appendString:@"Location EX\n"];
    [str appendFormat:@"위도 : %+f\n",_latitude];
    [_label setText:str];
    [self resizeLabel:_label];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate= newLocation.coordinate;
    _latitude = &coordinate.latitude;
    _longitude = &coordinate.longitude;
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied)
    {
        [self showAlert:@"" text:@"위치정보취득은 허가되어있지 않음"];
    }else{
        [self showAlert:@"" text:@"위치정보 취득 실패"];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
//    (CLHeading*)_heading = newHeading.trueHeading;
    
}





@end
