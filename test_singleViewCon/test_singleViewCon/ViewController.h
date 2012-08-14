//
//  ViewController.h
//  test_singleViewCon
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
    UITextView* locText;
}
@property (nonatomic,retain) IBOutlet UITextView *locText;
@property (nonatomic,retain)CLLocationManager* locationManager;

@end
