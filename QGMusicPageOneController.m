//
//  QGMusicPageOneController.m
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGMusicPageOneController.h"

@interface QGMusicPageOneController ()

@end

@implementation QGMusicPageOneController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QGMusicPageOneCell *cell =[_myTableView dequeueReusableCellWithIdentifier:@"CELL1"];
    if (indexPath.row==0) {
        cell.totalNumber.text=[NSString stringWithFormat:@"%lu",(unsigned long)_itemsArray.count];
        cell.listName.text=@"总列表";
        
    }
    else if(indexPath.row == 1){
        cell.totalNumber.text=[NSString stringWithFormat:@"%lu",(unsigned long)_loveArray.count];
        cell.listName.text=@"喜爱列表";
        
    }
    else{
        cell.totalNumber.text=[NSString stringWithFormat:@"%lu",(unsigned long)_nearArray.count];
        cell.listName.text=@"最近播放";
    }
    
    return cell;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    [self playbackStateChange:nil];//初始化播放button
    _username =@"username";
    //这里username 是登陆以后传值 并不是就是这个
    _itemsArray=[[NSMutableArray alloc]init];
    _loveArray=[[NSMutableArray alloc]init];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(controver:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlayer];//添加通知
    [self QGmusicPlayer];
    [self musicPlayButonSetting];
    
    QGFileManager *filePath =[[QGFileManager alloc]init];
    QGMusicPlayMusicPlayManager *musicManager=[[QGMusicPlayMusicPlayManager alloc]init];
    NSData *data=[[NSData alloc]initWithContentsOfFile:[filePath pathCreate:_username second:@"loveMusic.json"]];//这里返回的path是否是重新生成的，里面没有数据呢？username未初始化
    if (data!=nil) {
        _loveArray=[filePath readjson:data];
    }
    _mediaItemCollection=[musicManager getLocalMediaItemCollection];//获取全部音乐资料
    _itemsArray= [musicManager addArray:_mediaItemCollection ];//剥离音乐资料
    [[filePath getJsonData:_itemsArray] writeToFile:[filePath pathCreate:_username second:@"totalMusic.json"]atomically:YES];
    //存放
    
    [_musicPlayer setQueueWithItemCollection:_mediaItemCollection];//将歌曲信息加入到队列中，页面1点击播放即能顺序播放
    // Do any additional setup after loading the view.
}


- (void)setupRefresh {
    NSLog(@"setupRefresh -- 下拉刷新");
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refreshClick:refreshControl];
}


// 下拉刷新触发，在此获取数据
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    NSLog(@"refreshClick: -- 刷新触发");
    // 此处添加刷新tableView数据的代码
    [refreshControl endRefreshing];
    
    //设置喜好列表
    QGFileManager *filePath =[[QGFileManager alloc]init];
    NSData *data=[[NSData alloc]initWithContentsOfFile:[filePath pathCreate:_username second:@"loveMusic.json"]];//这里返回的path是否是重新生成的，里面没有数据呢？
    if (data!=nil) {
        _loveArray=[filePath readjson:data];
    }
        QGMusicPlayMusicPlayManager *musicManager=[[QGMusicPlayMusicPlayManager alloc]init];

        _mediaItemCollection=[musicManager getLocalMediaItemCollection];//获取全部音乐资料
        _itemsArray= [musicManager addArray:_mediaItemCollection ];//剥离音乐资料
    
    [self.myTableView reloadData];// 刷新tableView即可
}

-(void)musicPlayButonSetting{//这两个方法的循环机理是怎样的？
    if (_musicPlayer.playbackState==1) {//_play_name.tag本来就是默认为0的
        _play_name.titleLabel.text=@"暂停";
        _play_name.tag=1;
    }
    else{
        _play_name.titleLabel.text=@"播放";
        _play_name.tag=0;
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath=[self.myTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"toPage2"]) {
        
        
        if (indexPath.row==0) {
            if (_itemsArray.count!=0) {
        
            [segue.destinationViewController setValue:_itemsArray forKey:@"itemsArray"];

            }
            [segue.destinationViewController setValue:@"总列表" forKey:@"MusicTitle"];
            
        }
        else if (indexPath.row ==1)
        {

            NSMutableArray *array=[NSMutableArray arrayWithArray:_loveArray];
            if (_loveArray.count!=0) {
                [segue.destinationViewController setValue:array forKey:@"loveArray"];
            }
            [segue.destinationViewController setValue:@"喜好列表" forKey:@"MusicTitle"];

        }
        else if (indexPath.row ==2)
        {
            if (_nearArray.count!=0) {
        

                [segue.destinationViewController setValue:_nearArray forKey:@"nearArray"];
            }
            [segue.destinationViewController setValue:@"最近播放" forKey:@"MusicTitle"];

        }
        
    }
    
}

#pragma musicPlayer1
-(void) QGmusicPlayer{
    
    _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [_musicPlayer beginGeneratingPlaybackNotifications];
    [self addNotification];
}//为何要在两个页面都要addNotification？意思是不是：假如在本地点了播放，当用户再点击到app的主页面或者播放页面都随之相应的做出改变？

-(void)controver:(NSNotification *)notification{
    //正常播放歌曲时，将歌曲信息切换
    
}

-(void)volumeChange:(NSNotification *)notification{
    //音量变化时，改变音量UI，意味着得做音量进度条
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

- (IBAction)start:(id)sender {
    NSLog(@"Successfully instantiated a mediaplayer");
    if (_play_name.tag==0) {
        [_musicPlayer play];
        _play_name.tag=1;
    }
    else
    {
        [_musicPlayer pause];
        _play_name.tag=0;
    }
}

- (IBAction)next:(id)sender {
    [_musicPlayer skipToNextItem];
}
- (IBAction)forward:(id)sender {
    [_musicPlayer skipToPreviousItem];
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
