//
//  SecondViewController.h
//  120814_01
//
//  Created by Administrator on 8/14/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
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
