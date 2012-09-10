//
//  myRouteMapViewCont.m
//  astBikeDash
//
//  Created by Administrator on 9/11/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "myRouteMapViewCont.h"

@interface myRouteMapViewCont ()

@end

@implementation myRouteMapViewCont

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
