//
//  SecondViewController.m
//  test
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "SecondViewController.h"

enum filterButtonTag {
    FILTER_0    = 100,
    FILTER_1    = 101,
    FILTER_10   = 102,
    FILTER_100  = 103
};

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
}

- (void)viewDidUnload
{


    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)myPrefTotalDistResetButton:(id)sender {
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];

        float prefTotalDist = 0.0f;
        [pref setFloat:prefTotalDist forKey:@"prefTotalDist"];
        [pref synchronize];
    
    // 노티피케이션으로 바로 값을 바꿀 필요가 있음. - 타이머로 1초마다 갱신 처리로 일단 처리
}

- (IBAction)myFilterButton:(id)sender {
            NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    
    switch ([sender tag]) {
        case FILTER_0:
            
            [pref setFloat:-1.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;
            
        case FILTER_1:
            
            [pref setFloat:1.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_10:
            
            [pref setFloat:10.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_100:
            
            [pref setFloat:100.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;

            
        default:
            break;
    }
    
}
@end
