//
//  QGMusicPageThreePlayerController.m
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGMusicPageThreePlayerController.h"

@interface QGMusicPageThreePlayerController ()

@end

@implementation QGMusicPageThreePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    QGMusicPlayMusicPlayManager *musicManager =[[QGMusicPlayMusicPlayManager alloc]init];
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(controver:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlayer];
    
    [self QGmusicPlayer];
    [_musicPlayer setNowPlayingItem:[musicManager getSongItem:[_music_item objectForKey:@"music_id"] songItems:[musicManager getLocalMediaItemCollection]]];
    [self musicPlayButonSetting];
    _songName.text= _musicPlayer.nowPlayingItem.title;
    _singerName.text=_musicPlayer.nowPlayingItem.artist;//歌词是lyrics，显示用哪种框
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按键上文字的显示,似乎这个方法也是页面1和页面3共用的，要独立?看样子不行，因为对各种页面有操作
-(void)musicPlayButonSetting{
    if (_musicPlayer.playbackState==0) {//_play_name.tag本来就是默认为0的
        _play_name.tag=1;
        _play_name.titleLabel.text=@"暂停";
    }
    else{
        _play_name.tag=0;
        _play_name.titleLabel.text=@"播放";
        
        
    }
}



- (IBAction)forward:(id)sender {
    [self.musicPlayer skipToPreviousItem];
}

- (IBAction)play:(id)sender {
    if (_play_name.tag==0) {
        [self.musicPlayer play];
        _play_name.tag=1;
    }
    else{
        [self.musicPlayer pause];
        _play_name.tag=0;
    }
}

- (IBAction)next:(id)sender {

    [self.musicPlayer skipToNextItem];
}

#pragma musicPlayer1
-(void) QGmusicPlayer{//这个方法为何不能独立公用？
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];
        [self addNotification];
    }
}

-(void)controver:(NSNotification *)notification{
    //正常播放歌曲时，将歌曲信息切换
    _songName.text= _musicPlayer.nowPlayingItem.title;
    _singerName.text =_musicPlayer.nowPlayingItem.artist;
}

#pragma mark -notification
-(void)addNotification{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController systemMusicPlayer];//初步的解释是播放器只有一个
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:musicPlayer];
    //    [notificationCenter addObserver:self selector:@selector(volumeChange:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.musicPlayer];
}
-(void)playbackStateChange:(NSNotification *)notification{
    
    switch (_musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            _play_name.titleLabel.text=@"暂停";
            NSLog(@"正在播放。。。");
            break;
        case MPMusicPlaybackStatePaused:
            _play_name.titleLabel.text=@"播放";
            NSLog(@"播放暂停...");
            break;
        case MPMusicPlaybackStateStopped:
            _play_name.titleLabel.text=@"播放";
            
            NSLog(@"播放停止。。。");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"上一曲");
            break;
        case MPMusicPlaybackStateSeekingBackward:
            NSLog(@"下一曲");
            break;
        default:
            break;
    }
}
@end
