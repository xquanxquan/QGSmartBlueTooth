//
//  QGMusicPageThreePlayerController.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QGMusicPlayMusicPlayManager.h"
@interface QGMusicPageThreePlayerController : UIViewController
@property (nonatomic ,strong)NSDictionary *music_item;
@property (nonatomic,strong)MPMusicPlayerController *musicPlayer;//音乐播放器

- (IBAction)forward:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *play_name;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;


@end
