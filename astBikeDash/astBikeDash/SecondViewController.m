//
//  SecondViewController.m
//  test
//
//  Created by Administrator on 8/20/12.
//  Copyright (c) 2012 Administrator. All rights reserved.
//

#import "SecondViewController.h"

#define BTN_BGM_PLAY 0
#define BTN_SE_PLAY  1
#define BTN_VOL_UP   2
#define BTN_VOL_DOWN 3



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



//テキストボタンの生成
- (UIButton*)makeButton:(CGRect)rect text:(NSString*)text tag:(int)tag {
    UIButton* button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:text forState:UIControlStateNormal];
    [button setFrame:rect];
    [button setTag:tag];
    [button addTarget:self action:@selector(clickButton:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//オーディオプレーヤーの生成
- (AVAudioPlayer*)makeAudioPlayer:(NSString*)res {
    //リソースのURLの生成(1)
    NSString* path=[[NSBundle mainBundle] pathForResource:res ofType:@""];
    NSURL* url=[NSURL fileURLWithPath:path];
    
    //オーディオプレーヤーの生成(2)
    return [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                   error:NULL];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //BGM再生ボタンの生成
    UIButton* btnBGMStart=[self makeButton:CGRectMake(0,0,200,40)
                                      text:@"BGM再生/停止" tag:BTN_BGM_PLAY];
    [self.view addSubview:btnBGMStart];
    
    //SE再生ボタンの生成
    UIButton* btnSEPlay=[self makeButton:CGRectMake(0,50,200,40)
                                    text:@"SE再生" tag:BTN_SE_PLAY];
    [self.view addSubview:btnSEPlay];
    
    //ボリュームアップボタンの生成
    UIButton* btnVolUp=[self makeButton:CGRectMake(0,100,200,40)
                                   text:@"ボリュームアップ" tag:BTN_VOL_UP];
    [self.view addSubview:btnVolUp];
    
    //ボリュームダウンボタンの生成
    UIButton* btnVolDown=[self makeButton:CGRectMake(0,150,200,40)
                                     text:@"ボリュームダウン" tag:BTN_VOL_DOWN];
    [self.view addSubview:btnVolDown];
    
    //プレーヤーの生成
    _player[0]=[self makeAudioPlayer:@"re_bgm.mp3"] ;
    _player[1]=[self makeAudioPlayer:@"se.wav"] ;
    
    
    //ピッカービューの生成(4)
    _pickerView=[[UIPickerView alloc] init];
    [_pickerView setFrame:CGRectMake(0,200,320,230)];
    [_pickerView setBackgroundColor:[UIColor blackColor]];
    [_pickerView setDelegate:self];
    [_pickerView setShowsSelectionIndicator:YES];
    [self.view addSubview:_pickerView];
    _selectIdx=0;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)clickButton:(UIButton*)sender {
    if ([sender tag]==BTN_BGM_PLAY) {
        //BGMの再生と停止(3)
        if (!_player[0].playing) {
            _player[0].numberOfLoops=999;
            _player[0].currentTime=0;
            [_player[0] play];
        } else {
            [_player[0] stop];
        }
    } else if ([sender tag]==BTN_SE_PLAY) {
        //SEの再生(4)
        if (_player[1].playing) {
            _player[1].currentTime=0;
        } else {
            [_player[1] play];
        }
    } else if ([sender tag]==BTN_VOL_UP) {
        //オーディオプレーヤーのボリューム操作(5)
        float volume=_player[0].volume+0.2f;
        if (volume>1.0f) volume=1.0f;
        _player[0].volume=volume;
        _player[1].volume=volume;
    } else if ([sender tag]==BTN_VOL_DOWN) {
        //オーディオプレーヤーのボリューム操作(5)
        float volume=_player[0].volume-0.2f;
        if (volume<0.0f) volume=0.0f;
        _player[0].volume=volume;
        _player[1].volume=volume;
    }
    
     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//미디어 피커 관련


- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
	for (MPMediaItem *item in [mediaItemCollection items])
		NSLog(@"[%@] %@", [item valueForProperty:MPMediaItemPropertyArtist], [item valueForProperty:MPMediaItemPropertyTitle]);
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectMusic:(id)sender {
    myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    playlists = [myPlaylistsQuery collections];


    for (MPMediaPlaylist *playlist in playlists) {
        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        NSLog (@"%@",playlist);
 /*
        NSArray *songs = [playlist items];
        for (MPMediaItem *song in songs) {
            NSString *songTitle =
            [song valueForProperty: MPMediaItemPropertyTitle];
            NSLog (@"\t\t%@", songTitle);
        }
  */
    }
    /*
    mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
	mpc.delegate = self;
	mpc.prompt = @"아이템을 선택해 주세요";
	mpc.allowsPickingMultipleItems = YES;
	[self presentModalViewController:mpc animated:YES];
     */
}

//피커뷰 생성

- (NSUInteger)pickerView:(UIPickerView*)pickerView
 numberOfRowsInComponent:(NSUInteger)component {
    myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    playlists = [myPlaylistsQuery collections];
    return playlists.count;
}

//行のセルの取得(5)
- (UIView*)pickerView:(UIPickerView*)pickerView viewForRow:(NSInteger)row
         forComponent:(NSInteger)component reusingView:(UIView*)view {
    //セルの生成

    myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    playlists = [myPlaylistsQuery collections];
    
    UIView* cell=[[UIView alloc]
                   initWithFrame:CGRectMake(0,0,280,30)] ;
    
    //ラベルの生成
    UILabel* label=[[UILabel alloc] init] ;
    MPMediaPlaylist *playlist;
    
    [label setFrame:CGRectMake(0,0,280,40)];
    [label setBackgroundColor:[UIColor clearColor]];
 
    [cell addSubview:label];
    return cell;
}

//行の高さの取得(5)
- (CGFloat)pickerView:(UIPickerView*)pickerView
rowHeightForComponent:(NSInteger)component {
    return 30;
}

//ピッカー選択時に呼ばれる(5)
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectIdx=row;
}

//ボタンクリック時に呼ばれる
- (IBAction)clickButton2:(UIButton*)sender {

}

@end
