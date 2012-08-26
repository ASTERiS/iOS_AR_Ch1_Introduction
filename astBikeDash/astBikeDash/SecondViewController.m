//
//  SecondViewController.m
//  test
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize myPrefLabel;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
}

- (void)viewDidUnload
{

    [self setMyPrefLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)myPrefTotalDistResetButton:(id)sender {
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    myPrefLabel.text =[NSString stringWithFormat:@"%10.2f",[pref floatForKey:@"prefTotalDist"]];

/*
        float prefTotalDist = 0.0f;
        [pref setFloat:prefTotalDist forKey:@"prefTotalDist"];
        [pref synchronize];
*/
    
    // 노티피케이션으로 바로 값을 바꿀 필요가 있음. 
}
@end
