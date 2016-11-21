//
//  SportMainController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/2.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGSportMainController.h"
#define  pingmukuang  [[UIScreen mainScreen] bounds].size.width;
#define  pingmugao  ([[UIScreen mainScreen] bounds].size.height-60)/3;
@interface QGSportMainController ()

@end

@implementation QGSportMainController

@synthesize boundingMapRect;
@synthesize coordinate;
@synthesize polyline;
#pragma mark-locationDatainit
-(void)settingLocationData{
    self.sumDistance = 0;
    self.sumTime = 0;
    self.currentSpeed = 0;
    self.avgSpeed = 0;
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    //locationManager's delegate ==>> ViewController
    self.locationManager.delegate = self;
    //iOS 8之后需要请求了
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode =  MKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    
    self.tracking = YES;
    if ([CLLocationManager locationServicesEnabled]){
        if(self.locationManager == nil){
            self.locationManager = [[CLLocationManager alloc] init];
        }
        //locationManager's delegate ==>> ViewController
        self.locationManager.delegate = self;
        //iOS 8之后需要请求了
        [self.locationManager requestWhenInUseAuthorization];
        //power consumes most
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 健身模式
        self.locationManager.activityType = CLActivityTypeFitness;
        // 10米定位一次
        //        self.locationManager.distanceFilter = 10;
        // 开始实时定位
    }

}
#pragma  mark-targetSetting
-(NSMutableDictionary *)getData :(NSString *)name{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    QGFileManager *mgn=[[QGFileManager alloc]init];
    AppStatus *usrInfo=[AppStatus shareInstance];
    NSString *path=[mgn pathCreate:usrInfo.contextStr second:name];
    
    NSData *data=[NSData dataWithContentsOfFile:path];
    if (data!=nil) {
        dic= [mgn readjson:data];
        
    }
    return dic;
    
    
}

- (void)viewDidLoad {
    
    [self settingLocationData];//数据初始化
    NSMutableDictionary *dic=[self getData:@"SportTarget.json"];
    if ([dic objectForKey:@"speed"]) {
        _targetLabel.text=[NSString stringWithFormat:@"%@km/s",[dic objectForKey:@"speed"]];
    }
    self.navigationItem.rightBarButtonItem.enabled=NO;
    _select_Name.selectedSegmentIndex=1;
    [self beginMusicOberser];
    [super viewDidLoad];
    _QGSportCenter = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    
    
    
    
    //分配内存，不能用[NSMutableArray init] alloc];
    self.locations = [NSMutableArray array];
    
    [self showCurrentRegion];

    
    
}
#pragma  mark-Map
- (void)showCurrentRegion{
    
    CLLocationCoordinate2D theCoordinate;
    //
    theCoordinate.latitude = self.mapView.userLocation.coordinate.latitude;
    //    theCoordinate.longitude = 99.900000;
    theCoordinate.longitude = self.mapView.userLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(theCoordinate, 4000, 4000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(nonnull NSError *)error{
    NSLog(@"Location Error:%@", error.localizedDescription);
    // 应该弹出警告
}

//重写：当改变当前屏幕显示区域的时候， 被调用。
- (void)mapView:(MKMapView *) mapView regionDidChangeAnimated:(BOOL)animated{
    //一旦当前屏幕显示的区域改变，将会显示这个按钮。便于定位。
    //    self.ButtonPress.hidden = NO;
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}
//重写：只要用户的位置（定位服务）做出改变，被调用

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation（）");
    
    //用户大头针 信息

    
    
    //标签信息
    //    NSString *running = [NSString stringWithFormat:@"当前速度：%.1f米/秒，已运动距离：%.1f米，已用时间：%f秒，平均速度：%.1f米", self.currentSpeed, self.sumDistance, self.sumTime, self.avgSpeed];

    
    
    //    [self showCurrentRegion];
    //    [self.mapView regionDidChangeAnimated:YES];
    
    //是否处于开始跑步的状态的状态中
    if(!self.tracking){
        
        return;
    }
    //若是跑步状态中
    [self.mapView setCenterCoordinate:userLocation.coordinate animated: YES];
    //为存入数组中做准备
    CLLocation *newLocation = (CLLocation*)userLocation.location;
    
    //当数组中至少有一个元素
    if(self.locations.count>0){
        
        //减少初步定位时的漂移，每秒5米，过大了
        //        if(self.locations.count <= 3){
        //            // 出现距离过大，判定为还处于定位中，
        //            if(self.distance >= 15){
        //                // 所以清空目前已经存储在location数组中的位置
        //                [self.locations removeAllObjects];
        //                // 舍弃记录的距离，累计时间，平均速度；重新计算
        //                self.distance = 0;
        //                self.time = 0;
        //                self.avgSpeed = 0 ;
        //                // 直接返回该方法，等待下一次调用
        //                return;
        //            }
        //
        //        }
        
        CLLocation *lastLocation = ((CLLocation *)self.locations.lastObject);
        // 计算本次定位数据与上次定位数据之间的距离变化量
        CGFloat tinyDistance = [newLocation
                                distanceFromLocation:lastLocation];
        
        // 如果距离小于0.1米，则忽略本次数据，直接返回该方法
        if(tinyDistance < 0.1f ){
            return;
        }
        
        // 总距离累加
        self.sumDistance += [newLocation distanceFromLocation:lastLocation];
        // 计算本次定位数据与上次定位数据之间的时间差
        NSTimeInterval tinyTime = [newLocation.timestamp
                                   timeIntervalSinceDate:lastLocation.timestamp];
        // 当前速度（米/秒）
        self.currentSpeed = tinyDistance / tinyTime;
        
        // 累计时间
        self.sumTime += tinyTime;
        // 平均速度
        self.avgSpeed = self.sumDistance / self.sumTime;
        
        // 计算本次定位数据与上次定位数据之间的时间差
        
        //        绘制轨迹
        CLLocationCoordinate2D coords[2];
        //        CLLocation *lastLocation = ((CLLocation *)self.locations.lastObject);
        coords[0] = newLocation.coordinate;
        coords[1] = newLocation.coordinate;
        
        self.polyline = [MKPolyline polylineWithCoordinates:coords count:2];
        [self.mapView addOverlay:self.polyline];
    }
    [self.locations addObject:newLocation];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *localPolyline = (MKPolyline *)overlay;
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:localPolyline];
        [renderer setNeedsDisplay];
        // renderer.fillColor = [UIColor redColor];
        renderer.strokeColor = [UIColor blueColor];
        renderer.lineWidth = 2.0f;
        return renderer;
    }
    
    return nil;
}

-(void)locationManager:(nonnull CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 访问受限(苹果预留选项,暂时没用)
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
                // 在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权
                // 在iOS8.0之后跳转到"设置"界面代码
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:settingURL])
                {
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }else
            {
                NSLog(@"定位关闭，不可用");
            }
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            //  case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

//      UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 1)];
//    [footerView setBackgroundColor:[UIColor blackColor]];
//    
//    [_SportTableview setTableFooterView:footerView];

    // Do any additional setup after loading the view.

//#pragma mark-Notification
//-(void)subCharactistic:(NSNotification*)nti{
//    subCharactist=[nti.object[1] intValue];
//    if (subCharactist==1) {
//        [_QGSportPeripherar readValueForCharacteristic:nti.object[0]];
//        NSLog(@"%@",nti.object[0]);
//    }
//    
//}
#pragma mark-BluetoothPeripheral
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0){
    //名字改变
    NSLog(@"%@",peripheral.services);
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    //发现服务
    for (CBService *servise in peripheral.services) {
        
        NSLog(@"%@和%@",servise.UUID.UUIDString,servise.characteristics);
 

        [_QGSportPeripherar discoverCharacteristics:nil forService:servise];
        

    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    //订阅或者读相应的特征
    for (CBCharacteristic *characterist in service.characteristics) {


        NSLog(@"charcterist%@",characterist);
        for (NSNumber* i in [QGBlueToothTool getValue:characterist.properties ]) {
            if (i.intValue==CBCharacteristicPropertyRead) {
                [peripheral readValueForCharacteristic:characterist];
                
            }
            if (i.intValue==CBCharacteristicPropertyWrite) {
       
                
            }
            if (i.intValue==CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:YES forCharacteristic:characterist];
                
            }
        
        }
        


            //        [peripheral readValueForCharacteristic:c];//读取服务特征值
    
   
    }
}
-(void)SETSmartHeartrate :(int )k{
    if ([_SportItem1Name.text isEqualToString:@"心率"]) {
     
        if (_select_Name.selectedSegmentIndex==0&&k==0) {
            countLeaveEar++;
            if (countLeaveEar>=20) {
                countLeaveEar=0;
                [self pasueMusic];
                autoPlay=YES;
            }
            
            
        }else if(_select_Name.selectedSegmentIndex==0&&k!=0&&autoPlay==YES){
            //这里逻辑又问题
            autoPlay=NO;
            [self playMusic];
            
            [self restartSonglistToQueue];
            
            
            
        }else  if(countLeaveEar!=0){
            countLeaveEar=0;
        }
        if(_select_Name.selectedSegmentIndex==0&&k<60&&k>0){
            countSleep++;
            if (countSleep>30&&countNosport>30) {
                [self StopMusic];
                
                autoPlay=YES;
            }
            
        }
        
        
        
        _SportiTem1Value.text=[NSString stringWithFormat:@"%d",k];
        
    }

}
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    _RSSITEXT.text=[NSString stringWithFormat:@"%@",RSSI];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{

    if ([characteristic.UUID.UUIDString isEqualToString:@"2A37"]) {
        
           int  k=[QGChangeHexTool convertDataToHexIntForHeartRate:characteristic.value];//16进制转10进制
        [peripheral readRSSI];
        [self SETSmartHeartrate:k];
    //设置自动开启和暂停音乐
       
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"FFF2"]){
        int  k=[QGChangeHexTool convertDataToHexIntForHeartRateSOMIC:characteristic.value];
        
          [self SETSmartHeartrate:k];
        
        
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"]){
            int  k=[QGChangeHexTool convertDataToHexIntForBarttery:characteristic.value];
            
            _battaryvalue.text=[NSString stringWithFormat:@"%d％",k];
            
        
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"2A53"]){
        NSString * k=[QGChangeHexTool convertDataToHexIntForSpeed:characteristic.value];
        
        _SportiTem2Value.text=[NSString stringWithFormat:@"%@",k];
        if (k==0) {
            countNosport++;
        }
        else{
            countNosport=0;
        }
     
        
    }
    else if ([characteristic.UUID.UUIDString isEqualToString:@"FFF3"]){
        int  k=[QGChangeHexTool convertDataToHexIntForStepSOMIC:characteristic.value];
        _SportiTem2Value.text=[NSString stringWithFormat:@"%d",k];
        _SportiTem2CountName.text=@"步";
        _SportItem2Name.text=@"运动步数";

        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (subCharactist==2&&[characteristic.UUID isEqual:creditChr.UUID]) {
            [self setPostNitification:characteristic];
            
        }
        else if(subCharactist==1&&[characteristic.UUID isEqual:creditChr.UUID]){
            [self setPostNitification:characteristic];
            
        }
    });

    _QGSportPeripherar=peripheral;
    /****************************测试用******************/
   
    /****************************测试用******************/
//    [_SportDataSourse addObject: @{@"name":@"心率",@"value":@"40",@"count_name":@"BMP"}];

    //读值或者订阅值
}
-(void)setPostNitification:(CBCharacteristic *)chr{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCHrValue" object:chr.value];
}
#pragma mark-BluetoothCenterManager
//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
//    //关闭蓝牙的时候保存的数据
//    NSLog(@"断开连接");
//}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
        if([peripheral.name isEqualToString:@"Jabra PULSE Smart"]||[peripheral.name isEqualToString:@"S3"]){
          

            _QGSportPeripherar=peripheral;
            [_QGSportCenter stopScan];
//
        }
  


    
        NSLog(@"%@,信号强度:%@\n,广播消息:%@\n",peripheral,RSSI,advertisementData);
    
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    _bScBtn.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=YES;
//    CBUUID *uuid=[CBUUID UUIDWithString:@"2A07"];
    NSLog(@"连接成功: %@", peripheral);
   _QGSportPeripherar=peripheral;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    

}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    [_bScBtn setTitle:@"开始" forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem.enabled=NO;


         [self alertViewToUI:(2)];
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    [_bScBtn setTitle:@"开始" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.enabled=NO;

          [self alertViewToUI:(1)];
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message=[[NSString alloc]init];
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        

            message = @"初始化中，请稍后……";
            break;
        case CBCentralManagerStateResetting:
            message = @"设备不支持状态，过会请重试……";
            break;
        case CBCentralManagerStateUnsupported:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBCentralManagerStateUnauthorized:
            message = @"设备未授权状态，过会请重试……";
            break;
        case CBCentralManagerStatePoweredOff:
            message = @"尚未打开蓝牙，请在设置中打开……";
            break;
        case CBCentralManagerStatePoweredOn:
            message = @"蓝牙已经成功开启，稍后……";
            break;
        default:
            break;
    }
    [self alertViewToUI:central.state];
    NSLog(@"%@",message);
    [_QGSportCenter scanForPeripheralsWithServices:nil options:nil];
    
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


#pragma mark- viewSetting

- (IBAction)QGBeginScanf:(id)sender {
    [self.locationManager startUpdatingLocation];
    
    if(_QGSportPeripherar!=nil){
    [_QGSportCenter connectPeripheral:_QGSportPeripherar options:nil];
        NSLog(@"连接中");
        _status.text=@"进行中";
    }
    else{
        [self alertViewToUI:(0)];
    }

}
-(void)alertViewToUI:(int)flat{//管理弹出框
    UIAlertController *alertController;
    if (flat==0) {
        alertController= [UIAlertController alertControllerWithTitle:@"打开蓝牙才能搜索" message:@"请确定设备已经开启" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新搜索" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){NSLog(@"取消");
            [_QGSportCenter scanForPeripheralsWithServices:nil options:nil];
        }
                                       ];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"确定");}];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        _bScBtn.enabled=YES;

    }
    else if(flat==1){
            alertController= [UIAlertController alertControllerWithTitle:@"蓝牙连接失败" message:@"蓝牙设备已经关闭或者超出距离" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"超距离或者蓝牙设备关闭");}];
               [alertController addAction:okAction];
        _bScBtn.enabled=YES;

    }
    else if(flat==2){
        alertController= [UIAlertController alertControllerWithTitle:@"蓝牙设备连接失败" message:@"请确定蓝牙已经打开或者重启蓝牙" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"连接没有成功");}];
        [alertController addAction:okAction];
        _bScBtn.enabled=YES;

    }
    else if(flat==4){
        alertController= [UIAlertController alertControllerWithTitle:@"蓝牙连接断开" message:@"如果要服务请重新打开蓝牙" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){NSLog(@"连接没有成功");}];
        [alertController addAction:okAction];
        _bScBtn.enabled=YES;
    }
    if (alertController!=nil) {
        [self presentViewController:alertController animated:YES completion:nil];

    }
    
}
- (IBAction)QGStopScanf:(id)sender {
    if(play_flat!=1){
    [self addMusicList];
    [self restartSonglistToQueue];

    }
    else {
        [self pasueMusic];
    }

  
    
    [_musicPlay beginGeneratingPlaybackNotifications];
}






- (IBAction)select:(id)sender {
    if (_select_Name.selectedSegmentIndex==0) {
        NSLog(@"选择确定");
        autoPlay=YES;
    }
    else{
          autoPlay=NO;
        NSLog(@"选择否定");

    }
    
}


#pragma -mark MUSIC
-(void)playMusic{
    [_musicPlay play];
    [_pMBtn setTitle:@"暂停播放" forState:UIControlStateNormal];
}
-(void)StopMusic{
    [_musicPlay stop];
    [_pMBtn setTitle:@"开始播放" forState:UIControlStateNormal];
}
-(void)pasueMusic{
    [_musicPlay pause];
    [_pMBtn setTitle:@"开始播放" forState:UIControlStateNormal];
}
-(void)beginMusicOberser{
    dispatch_async(dispatch_get_main_queue(), ^{
        _musicPlay = [MPMusicPlayerController systemMusicPlayer];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter  removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlay];
          [notificationCenter  removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_musicPlay];
        [notificationCenter addObserver:self selector:@selector(handle_NowPlayingItemChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_musicPlay];
        //     [notificationCenter addObserver:self selector:@selector(handle_VolumeDidChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification obsject:musicPlayer];
        
        [notificationCenter addObserver:self selector:@selector(handle_StateDidChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_musicPlay];
        
        [_musicPlay beginGeneratingPlaybackNotifications];
        
    });
}
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"Media Picker was cancelled");
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)handle_StateDidChange:(NSNotification *)notification {
    MPMusicPlayerController * musicPlayer = [notification object];
    int i =musicPlayer.playbackState;
    play_flat=i;
    
    NSLog(@"目前播放状态%d",i);
}
//-(void)handle_VolumeDidChanged:(NSNotification *)notification {
//    MPMusicPlayerController * musicPlayer = [notification object];
//    NSLog(@"消息进来了");
//    _info1.text=musicPlayer.nowPlayingItem.title;
//}
-(void)handle_NowPlayingItemChanged:(NSNotification *)notification {
    MPMusicPlayerController * musicPlayer = [notification object];
    NSLog(@"消息进来了%@",musicPlayer.nowPlayingItem.title);

}
//- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
//{
//    
//    
//    //MPMusicPlayerController类可以播放音乐库中的音乐
//    //MPMusicPlayerController提供两种播放器类型，一种是applicationMusicPlayer，一种是iPodMusicPlayer，这里用iPodMusicPlayer。前者在应用退出后音乐播放会自动停止，后者在应用停止后不会退出播放状态。
//    MPMusicPlayerController *musicPC = [[MPMusicPlayerController alloc]init];
//    
//    //MPMusicPlayerController加载音乐不同于前面的AVAudioPlayer,AVAudioPlayer是通过一个文件路径来加载,而MPMusicPlayerController需要一个播放队列,正是由于它的播放音频来源是一个队列，因此MPMusicPlayerController支持上一曲、下一曲等操作。
//    [musicPC setQueueWithItemCollection:mediaItemCollection];
//    [musicPC play];
//    
//    
//    
//}
//
-(void)restartSonglistToQueue{//重新将歌单添加到队列
    
    if (_musicPlay.nowPlayingItem!=nil) {
        [self playMusic];
        
        
    }
    else{
        if (_songList!=nil) {
            [_musicPlay setQueueWithItemCollection:_songList];
            
           [self playMusic];
        }
        
    }

}
-(void)addMusicList{//添加全部歌曲
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
//    MPMediaPropertyPredicate *predicate=[MPMediaPropertyPredicate predicateWithValue:@"少儿歌曲" forProperty:MPMediaItemPropertyArtist];
//    
//    [everything addFilterPredicate:predicate];
//    
    //    NSArray *itemsFromArtistQuery = [everything items];
    //    NSLog(@"%@",itemsFromArtistQuery);
//    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    
    int i=0;
    NSMutableArray<MPMediaItem *> * items=[[NSMutableArray<MPMediaItem *> alloc]init];
    for (MPMediaItem *song in itemsFromGenericQuery) {
        if (i>=1) {
            [items addObject:song];
        }
        
        
        
        i++;
        _songList= [MPMediaItemCollection collectionWithItems:items];
    }

}

#pragma mark- SEGUE

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"jabraDetail"])
    {
        QGJabraDetailController *DetailVc = segue.destinationViewController;
        
        DetailVc.datasource=_QGSportPeripherar;
        DetailVc.AtoB=^(CBCharacteristic *chr,int i){
            if(i==1){
                [_QGSportPeripherar readValueForCharacteristic:chr];
            }
            creditChr=chr;
            subCharactist=i;
            NSLog(@"%d",i);
        };
        
//        [segue2 setValue:title forKey:@"itemTitle"];
        
    }
}
#pragma mark - BUNDEL
-(void)setBundle:(NSString *)path Data:(NSData*)data{
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) ;
    
    NSString *cacheDir=[array objectAtIndex:0];
    NSString *strPath=[cacheDir stringByAppendingPathComponent:path];
    NSLog(@"保存路径%@",strPath);
    NSFileHandle *handle=[NSFileHandle fileHandleForWritingAtPath:strPath];
    [handle writeData:data];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -settingPickView
- (IBAction)selectDataBtn:(UIButton *)sender {
    //设置动画的名字
  /*  [UIView beginAnimations:@"Animation" context:nil];
        //设置动画的间隔时间
        [UIView setAnimationDuration:0.20];
        //??使用当前正在运行的状态开始下一段动画
        [UIView setAnimationBeginsFromCurrentState: YES];
        //设置视图移动的位移
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
         //设置动画结束
    [UIView commitAnimations];
   */
    _mainView.hidden=NO;
    
    _pickViewData=[NSMutableArray arrayWithArray:@[@"运动距离",@"运动速度",@"消耗卡路里",@"运动步数"]];
    _DatapickerView.showsSelectionIndicator=YES;
    _DatapickerView.backgroundColor=[UIColor grayColor];
    _DatapickerView.hidden=NO;

    self.DatapickerView.delegate=self;
    self.DatapickerView.dataSource=self;

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickViewData.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickViewData[row];
}
- (IBAction)pickviewCancelBtn:(id)sender {
    _mainView.hidden=YES;
}
- (IBAction)pickViewEnterBtn:(id)sender {
    _mainView.hidden=YES;
}
@end
