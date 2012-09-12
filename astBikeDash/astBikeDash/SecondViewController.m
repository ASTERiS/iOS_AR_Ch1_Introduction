//
//  SecondViewController.m
//  test
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "SecondViewController.h"

enum filterButtonTag {
    FILTER_00   = 100,
    FILTER_01   = 101,
    FILTER_02   = 102,
    FILTER_03   = 103,
    FILTER_04   = 104,
    FILTER_05   = 105,
    FILTER_06   = 106,
    FILTER_07   = 107,
    FILTER_08   = 108,
    FILTER_09   = 109,
    FILTER_AU   = 200
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
        case FILTER_00:
            
            [pref setFloat:-1.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;
            
        case FILTER_01:
            
            [pref setFloat:0.1f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_02:
            
            [pref setFloat:0.2f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_03:
            
            [pref setFloat:0.3f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_04:
            
            [pref setFloat:0.4f forKey:@"prefFilter"];
            [pref synchronize];
            break;
            
        case FILTER_05:
            
            [pref setFloat:0.5f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_06:
            
            [pref setFloat:0.6f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_07:
            
            [pref setFloat:0.7f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_08:
            
            [pref setFloat:0.8f forKey:@"prefFilter"];
            [pref synchronize];
            break;
        case FILTER_09:
            
            [pref setFloat:0.9f forKey:@"prefFilter"];
            [pref synchronize];
            break;
            

           
            
        case FILTER_AU:
            
            [pref setFloat:-3.0f forKey:@"prefFilter"];
            [pref synchronize];
            break;

            
        default:
            break;
    }
    
}

- (IBAction)gpsTypeButton:(id)sender {
                NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    
    switch ([sender tag]) {
        case 300:
            
            [pref setFloat:0 forKey:@"prefGPSType"];
            [pref synchronize];
            break;
            
            
        case 301:
            
            [pref setFloat:1 forKey:@"prefGPSType"];
            [pref synchronize];
            break;
            
            
        default:
            break;
    }
}
@end
