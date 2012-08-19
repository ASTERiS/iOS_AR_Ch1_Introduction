//
//  SecondViewController.h
//  test
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SecondViewController : UIViewController <MPMediaPickerControllerDelegate,UIPickerViewDelegate> {
    AVAudioPlayer* _player[2];
    MPMediaPickerController* mpc;
    MPMediaQuery *myPlaylistsQuery;
    NSArray *playlists;
    UIPickerView*   _pickerView;
    NSMutableArray* _items;
    int             _selectIdx;
}

- (IBAction)selectMusic:(id)sender;




@end
