//
//  FirstViewController.h
//  120814_01
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate>
{
    UITextView* locationTextView;
    UITextView* headingTextView;
    CLLocationManager *locationManager;
    //    CLLocationManager *locationManager2;
    CLRegion *region;
    
}
@property (nonatomic, retain) IBOutlet UITextView *locationTextView;
@property (nonatomic, retain) IBOutlet UITextView *headingTextView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

-(void)startStandardUpdates;
-(void)startSignificantChangeUpdates;
-(void)startRegionMonitoring;



@end
