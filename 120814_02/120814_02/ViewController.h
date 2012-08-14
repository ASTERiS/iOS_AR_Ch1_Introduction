//
//  ViewController.h
//  120814_02
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    
    UILabel*    _label;
    CLLocationManager* _locationManager;
    CLLocationDegrees* _latitude;
    CLLocationDegrees* _longitude;
    CLLocationDirection* _heading;
    
}


@end
