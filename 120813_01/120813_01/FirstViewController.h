//
//  FirstViewController.h
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FirstViewController : UIViewController <CLLocationManagerDelegate>
{
    UITextView* locationTextView;
//    CLLocationManager *locationManager;
    
    
}

@property (nonatomic, retain) IBOutlet UITextView *locationTextView;

-(void)startStandardUpdates;
-(void)startSignificantChangeUpdates;
-(void)startRegionMonitoring;



@end
