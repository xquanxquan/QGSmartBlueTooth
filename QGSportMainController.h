//
//  SportMainController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/2.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import<CoreBluetooth/CoreBluetooth.h>
#import <MediaPlayer/MediaPlayer.h>
#import "QGJabraDetailController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QGFileManager.h"
#import "AppStatus.h"
@interface QGSportMainController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,MPMediaPickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MKMapViewDelegate, CLLocationManagerDelegate,MKOverlay>
{
    int countLeaveEar;//统计失去心率次数 （1次/s）
    int countSleep;//连续统计心率低于60
    int countNosport;//计算连续加速度为0的次数
    int subCharactist;// 订阅的值 为1处于读取状态,为0处于正常状态,为2处于订阅状态,为3处于写状态
    CBCharacteristic *creditChr;//传过来的的特性
    BOOL  autoPlay;//默认为NO 如果为YES 就打开只能播放
    int play_flat;//

}
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (nonatomic , assign) CGFloat sumDistance;
@property (nonatomic , assign) CGFloat sumTime;
@property (nonatomic , assign) CGFloat currentSpeed;
@property (nonatomic , assign) CGFloat avgSpeed;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (nonatomic, getter=isTracking) BOOL tracking;
@property (nonatomic) BOOL tracking;
@property (nonatomic, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIPickerView *DatapickerView;
@property (strong, nonatomic) IBOutlet UILabel *RSSITEXT;
@property(nonatomic,strong)MPMusicPlayerController *musicPlay;//音乐控制
@property(nonatomic,strong)NSMutableArray *pickViewData;//音乐控制
- (IBAction)selectDataBtn:(UIButton *)sender;
@property (nonatomic,strong)CBCentralManager * __block QGSportCenter;//蓝牙控制中心


- (IBAction)QGStopScanf:(id)sender;
- (IBAction)QGBeginScanf:(id)sender;
@property(strong,atomic) MPMediaItemCollection *songList;//歌曲名单
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem1Value;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem1CountName;
@property (strong, nonatomic) IBOutlet UILabel *SportItem1Name;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem2Value;
@property (strong, nonatomic) IBOutlet UILabel *SportiTem2CountName;
@property (strong, nonatomic) IBOutlet UILabel *SportItem2Name;
@property (strong, nonatomic) IBOutlet UILabel *batterName;
@property (strong, nonatomic) IBOutlet UILabel *battaryvalue;
- (IBAction)select:(id)sender;

- (IBAction)pickViewEnterBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *select_Name;
- (IBAction)pickviewCancelBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIButton *pMBtn;
@property (strong, nonatomic) IBOutlet UIButton *bScBtn;
@property(nonatomic,strong)CBPeripheral*QGSportPeripherar;//广播者
/*******************************************bug*******************************/
//播放第一首歌的时候按上一首会让歌曲进程结束
//
//
//
@end
