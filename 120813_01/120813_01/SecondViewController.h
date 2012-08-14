//
//  SecondViewController.h
//  120813_01
//
//  Created by Chan-Gyoon Park on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController <CLLocationManagerDelegate>
{
    UILabel*    _label;
    CLLocationManager* _locationManager;
    CLLocationDegrees* _latitude;
    CLLocationDegrees* _longitude;
    CLLocationDirection* _heading;
}

@end
