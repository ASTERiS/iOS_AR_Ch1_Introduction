//
//  myRouteMapCont.h
//  astBikeDash
//
//  Created by Administrator on 9/11/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>

@interface myRouteMapCont : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
- (IBAction)closeModal;
@end
