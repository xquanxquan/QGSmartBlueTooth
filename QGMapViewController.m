//
//  ViewController.m
//  MapViewV3
//
//  Created by 12345 on 25/9/16.
//  Copyright © 2016年 12345. All rights reserved.
//

#import "QGMapViewController.h"

@interface QGMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

//@property (nonatomic, getter=isTracking) BOOL tracking;
@property (nonatomic) BOOL tracking;
@property (nonatomic, nonatomic) MKPolyline *polyline;

//@property (nonatomic) Boolean defferingUpdate;
//@property float distance;
@property (strong, nonatomic) NSMutableArray *locations;
@property (nonatomic , assign) CGFloat sumDistance;
@property (nonatomic , assign) CGFloat sumTime;
@property (nonatomic , assign) CGFloat currentSpeed;
@property (nonatomic , assign) CGFloat avgSpeed;
//@property (weak, nonatomic) CLRegion *region;
//- (void)showCurrentRegion;
@end

@implementation QGMapViewController
//<MKMapViewDelegate, CLLocationManagerDelegate>
@synthesize boundingMapRect;
@synthesize coordinate;
@synthesize polyline;
//这两个东西没给
@synthesize locationLabel;
@synthesize locationTitleLabel;
@synthesize sumDistanceLabel;
@synthesize sumTimeLabel;
@synthesize avgSpeedLabel;
@synthesize currentSpeedLabel;

//@synthesize defferingUpdate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.location
    self.sumDistance = 0;
    self.sumTime = 0;
    self.currentSpeed = 0;
    self.avgSpeed = 0;
    self.tracking = NO;
    
    self.stopButton.hidden = YES;
    self.startButton.hidden = NO;
//    dd
    self.mapView.delegate = self;
//    self.defferingUpdate = NO;
//    self.locationManager.delegate = self;
    
    
//    self.locationManager = [[CLLocationManager alloc]init];
//    [self.locationManager requestWhenInUseAuthorization];
//    self.locationManager.allowsBackgroundLocationUpdates = YES;
//    self.locationManager.activityType = CLActivityTypeFitness;
//    self.locationManager.pausesLocationUpdatesAutomatically = YES;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
//     [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
//    [self.locationManager startUpdatingLocation];

    //
    if ([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc] init];
        //locationManager's delegate ==>> ViewController
        self.locationManager.delegate = self;
        //iOS 8之后需要请求了
        [self.locationManager requestWhenInUseAuthorization];
        //power consumes most
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        // 健身模式
//        self.locationManager.activityType = CLActivityTypeFitness;
//        // 开始实时定位
//        [self.locationManager startUpdatingLocation];
    }
//    }else{
//        NSLog( @"无法使用定位服务！" );
//        self.tracking = NO;
//        //        add reminder of openning the location service
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"home_cannot_locate", comment:@"无法进行定位") message:NSLocalizedString(@"home_cannot_locate_message", comment:@"请检查您的设备是否开启定位功能") delegate:self cancelButtonTitle:NSLocalizedString(@"common_confirm",comment:@"确定") otherButtonTitles:nil, nil];
//        //                [alert show];
//        //
//        //        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法使用定位服务！"
//        //                                                                       message:@"解决办法：在通用设置中中检查是否开启定位功能"
//        //                                                                preferredStyle:UIAlertControllerStyleAlert];
//        //        // 这里用block 来实现，可能是退出app或者停止跟踪用户位置。
//        //        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//        //                                                              handler:^(UIAlertAction * action) {
//        //                                                                  // 按钮状态恢复
//        //                                                                  self.stopButton.hidden = YES;
//        //                                                                  self.startButton.hidden = NO;
//        //                                                              }];
//        
//        //        [alert addAction:defaultAction];
//        
//        
//        
//        //        [self presentViewController:alert animated:YES completion:nil];
//    }
    
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode =  MKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    
     [self showCurrentRegion];

    locationLabel.text = [NSString stringWithFormat:@"点击开始"];
    
}



//重写：当改变当前屏幕显示区域的时候， 被调用。
- (void)mapView:(MKMapView *) mapView regionDidChangeAnimated:(BOOL)animated{
    //一旦当前屏幕显示的区域改变，将会显示这个按钮。便于定位。
//    self.ButtonPress.hidden = NO;
    
}
//重写：只要用户的位置（定位服务）做出改变，被调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation（）");
    
    //用户大头针 信息
    userLocation.title = @"我在这里";
    
    NSString *speedInfo = [NSString stringWithFormat:@"当前速度：%.1f米", self.currentSpeed];
    userLocation.subtitle = speedInfo;
    

    currentSpeedLabel.text = [NSString stringWithFormat:@"当前速度：%.1f米/秒", self.currentSpeed];
    avgSpeedLabel.text =[NSString stringWithFormat:@"平均速度：%.1f米/秒", self.avgSpeed];
    sumDistanceLabel.text = [NSString stringWithFormat:@"累计距离：%.1f米", self.sumDistance];
    sumTimeLabel.text = [NSString stringWithFormat:@"累计时间：%.1f秒", self.sumTime];
    
    
    //标签信息
//    NSString *running = [NSString stringWithFormat:@"当前速度：%.1f米/秒，已运动距离：%.1f米，已用时间：%f秒，平均速度：%.1f米", self.currentSpeed, self.sumDistance, self.sumTime, self.avgSpeed];
    locationLabel.text =[NSString stringWithFormat:@"Running"];
    
    
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

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(nonnull NSError *)error{
    NSLog(@"Location Error:%@", error.localizedDescription);
    // 应该弹出警告
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// adjust scale
- (void)showCurrentRegion{
    
    CLLocationCoordinate2D theCoordinate;
//    
    theCoordinate.latitude = self.mapView.userLocation.coordinate.latitude;
//    theCoordinate.longitude = 99.900000;
    theCoordinate.longitude = self.mapView.userLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(theCoordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
- (IBAction)startRecording:(id)sender {
    self.stopButton.hidden = NO;
    self.startButton.hidden = YES;
    self.tracking = YES;
    locationLabel.text = [NSString stringWithFormat:@"正在记录距离"];
    NSLog(@"startPressed");
    self.sumDistance = 0;
    
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
        [self.locationManager startUpdatingLocation];
    }
    
    
    //分配内存，不能用[NSMutableArray init] alloc];
    self.locations = [NSMutableArray array];
    
    [self showCurrentRegion];
    
    
}

- (IBAction)stopRecording:(id)sender {
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    //确认是否停止记录，如果
    self.tracking = NO;
    //先存储
    //后清空
    self.sumDistance = 0;
    self.sumTime = 0;
    self.currentSpeed = 0;
    self.avgSpeed = 0;
    
//    [self.mapView removeOverlay:self.polyline];
    
    [self.locations removeAllObjects];
    NSLog(@"StopPressed");
//    locationLabel.text = [NSString stringWithFormat:@"已经停止记录。当前累计行程：%.1f米",self.distance];
//    locationLabel.text = [NSString stringWithFormat:@"Method called: didUpdateLocations()"];
    
//    locationLabel.text = [NSString stringWithFormat:@"累计距离：%.1f米，累计时间：%f秒，平均速度：%.1f米", self.sumDistance, self.sumTime, self.avgSpeed];
    
    [self.locationManager stopUpdatingLocation];
   
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
//    NSLog(@"didUpdateLocations().");
//    [locationTitleLabel setText:@"调用 didUpdateLocations()."];
//    locationLabel.text = [NSString stringWithFormat:@"Method called: didUpdateLocations()"];
    
//    if(!deferringUpdates){
//        
//    }
    //延迟采集策略，每隔一定时间或者一定距离达到时，才将GPS传感器的数据（数组内有多个位置）统一处理。
    //if(!defferingUpdate){
      //  CLLocationDistance distance = 30;
        //NSTimeInterval time = 60;
        //[self.locationManager allowDeferredLocationUpdatesUntilTraveled:distance timeout:time];
        //defferingUpdate = YES;
    //}
    
    //在前台运行，只要有新位置产生（数组内只有一个位置），立即进行处理。
    //由于目前没有开启省电模式（DelayMode），所以这个数组只有一个。所以，for循环只循环一次
//    for (CLLocation *location in locations) {
//        CLLocation *newLocation = location;
////        NSLog(@"%@", newLocation.description);
//        
//        
//        if (self.locations.count > 0) {
//            
//            // 上一个位置
//            CLLocation *lastLocation = ((CLLocation *)self.locations.lastObject);
//            
//            // 计算本次定位数据与上次定位数据之间的距离变化量
//            CGFloat tinyDistance = [newLocation
//                                distanceFromLocation:lastLocation];
//            
//            // 如果距离小于0.1米，则忽略本次数据，直接返回该方法
//            if(tinyDistance < 0.1f ){
//                return;
//            }
//            
//            // 总距离累加
//            self.distance += [newLocation distanceFromLocation:lastLocation];
//            
//            // 特殊情况的处理：初期定位未完成导致的漂移
//            // 如果距离过大（由于还处于初期定位中）
//            if(self.locations.count <= 3){
//                // 出现距离过大，判定为还处于定位中，
//                if(self.distance >= 15){
//                    // 所以清空目前已经存储在location数组中的位置
//                    [self.locations removeAllObjects];
//                    // 舍弃记录的距离，累计时间，平均速度；重新计算
//                    self.distance = 0;
//                    self.time = 0;
//                    self.avgSpeed = 0 ;
//                    // 直接返回该方法，等待下一次调用
//                    return;
//                }
//            }
//            
//            
//            // 计算本次定位数据与上次定位数据之间的时间差
//            NSTimeInterval tinyTime = [newLocation.timestamp
//                                       timeIntervalSinceDate:lastLocation.timestamp];
//            
//            
//            NSLog(@"每次距离：%f", tinyDistance);
//            // 当前速度（米/秒）
//            CGFloat speed = tinyDistance / tinyTime;
//            
//                    //update the screen center
////                    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
////                    [self.mapView setRegion:mapRegion];
//            
//            // 累计时间
//            self.time += tinyTime;
//            // 平均速度
//            self.avgSpeed = self.distance / self.time;
//            NSString *speedInfo = [NSString stringWithFormat:@"当前速度：%.1f米/秒，已运动距离：%.1f米，已用时间：%f秒，平均速度：%.1f米", speed, self.
//                                  distance, self.time, self.avgSpeed];
//            locationLabel.text =speedInfo;
//            
//            
//            
//        }
//        //
//        [self.locations addObject:newLocation];
//        
        
        
        
        
        
//        NSLog(@"%lu",(unsigned long)self.locations.count);
//    }
    
    
    //如果开启了DelayMode，将会有地理位置的位置将会产生多于一个的数组；
//    if(locations.count > 1){
//        //locationLabel.text =[NSString stringWithFormat:@"当前采集到缓存的多个地理位置的数组，需要重新处理"];
//        [locationTitleLabel setText:@"已经停止"];
//        self.startButton.hidden = NO;
//        self.stopButton.hidden = YES;
//        [self.locationManager stopUpdatingLocation];
////        [self.mapView stopRecording];
//    }
//    NSLog(@"#############");
    
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR:%@",error);
}
//延迟采集地理位置
//-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
  //  NSLog(@"Method called: didFinishDefferedUpdatesWithError.");
    //NSLog(@"%@",error);
    //self.defferingUpdate = NO;
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    [locationTitleLabel setText:@"调用 rendererForOverlay"];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

//-(void)setLocationManager:(CLLocationManager *)locationManager{
//
//}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

