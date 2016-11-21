//
//  QGMusicPageOneController.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QGFileManager.h"
#import "QGMusicPlayMusicPlayManager.h"
#import "QGMusicPageOneCell.h"
@interface QGMusicPageOneController : UIViewController<UITableViewDataSource,UITableViewDelegate,MPMediaPickerControllerDelegate>

@property (strong,nonatomic)MPMusicPlayerController *musicPlayer;//音乐播放器
@property (strong,nonatomic)NSMutableArray *itemsArray;//总列表
@property (strong,nonatomic)NSMutableArray *loveArray;//喜好列表
@property(strong,nonatomic)NSMutableArray *nearArray;//最近播放
@property (strong,nonatomic)MPMediaItemCollection *mediaItemCollection;
@property (strong,nonatomic)id username;

@property (strong,nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *play_name;


@end
