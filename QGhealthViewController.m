
//
//  QGhealthViewController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/11/20.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGhealthViewController.h"

@interface QGhealthViewController ()
//@property (nonatomic, getter=isTracking) BOOL tracking;
@property (nonatomic) BOOL tracking;

//@property (nonatomic) Boolean defferingUpdate;
//@property float distance;

//@property (weak, nonatomic) CLRegion *region;
//- (void)showCurrentRegion;
@end

//<MKMapViewDelegate, CLLocationManagerDelegate>


@implementation QGhealthViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //建立地图管理类
    [self setInitSetting];

}
-(void)setInitSetting{
    
    allTime=5;
    proValue=0;
    [_timeline setProgress:0.0];
    _AlltimeLabel.text=[NSString stringWithFormat:@"/%d%d:%d%d",(int)allTime/60/10,(int)allTime/60%10,(int)allTime%60/10,(int)allTime%60%10];
    _goTimeLabel.text=[NSString stringWithFormat:@"%d:%d",0,0];
    _scanslabel.text=@"尽量在12分钟跑更多的距离";
    _item1Label.text=@"0";
    _countscanlabel.text=@"距离";
    _countName.text=@"米";
    [_btnName setTitle:@"开始" forState:UIControlStateNormal];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation{
  
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
-(void)changeProgress

{
    
    proValue =proValue+ 1.0; //改变proValue的值

    if(proValue > allTime)
        
    {
        proValue=0;
        //停用计时器
        
        [timer invalidate];
        [self.locationManager stopUpdatingLocation];
        AppStatus *userInfo=[AppStatus shareInstance];
        QGFileManager *mag=[[QGFileManager alloc]init];
     NSString*path=   [mag pathCreate:userInfo.contextStr second:@"UserInfo.json"];
        NSData *data=[NSData dataWithContentsOfFile:path];
        NSMutableDictionary *dic;
        if (data !=nil) {
          dic=  [mag readjson:data];
        }
        QGHealthTestTool *tool=[[QGHealthTestTool alloc]init];
        NSString *sex=[dic objectForKey:@"usrsex"];
        NSString *age=[dic objectForKey:@"usrage"];

        if ([sex isEqualToString:@""]||sex==nil) {
            sex=@"male";
        }
        if ([age isEqualToString:@""]||age==nil) {
            age=@"20";
        }
       NSString*result= [tool CooperTest:sex Length:self.sumDistance UserAge:age.intValue];
        [self showAlert:result];
        [self setInitSetting];
    }
    
    else
        
    {
        _goTimeLabel.text=[NSString stringWithFormat:@"%d%d:%d%d",proValue/60/10,proValue/60%10,proValue%60/10,proValue%60%10];
        double k=proValue;
        [_timeline setProgress:k/allTime];
        NSLog(@"%f",k/allTime);
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"didUpdateUserLocation（）");

    CLLocation *newLocation = locations[0];
    
    //当数组中至少有一个元素
    if(self.locations.count>5){
        
        
        
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
        _item1Label.text=[NSString stringWithFormat:@"%.1f",self.sumDistance];

        // 计算本次定位数据与上次定位数据之间的时间差
        
        // 当前速度（米/秒）
        
        
    }
    [self.locations addObject:newLocation];
}
- (void)showAlert:(NSString *)str {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //    [alertV show];
}
- (IBAction)beginBtn:(id)sender {
    if ([sender tag]==0) {
        proValue=0;
        self.locations =[[NSMutableArray alloc]init];
        
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            // 创建位置管理者对象
            self.locationManager.delegate = self; // 设置代理
            // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
            self.locationManager.distanceFilter = 100;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度(精度越高越耗电)
            [self.locationManager startUpdatingLocation]; // 开始更新位置
        }
        
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
        [sender setTag:1];
        [sender setTitle:@"结束" forState:UIControlStateNormal];
    }
    else{
        [sender setTag:0];
        [self setInitSetting];
        [self.locationManager stopUpdatingLocation ];
    
    }
  
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"获取定位失败");
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
