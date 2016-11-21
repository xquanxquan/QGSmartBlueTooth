//
//  QGhealthViewController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/11/20.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QGFileManager.h"
#import "QGHealthTestTool.h"
#import "AppStatus.h"

@interface QGhealthViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>{
    
    int proValue;
    float allTime;
    NSTimer *timer;
}
- (IBAction)back:(id)sender;
@property (strong, nonatomic) NSMutableArray *locations;
@property (nonatomic , assign) CGFloat sumDistance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIProgressView *timeline;
@property (strong, nonatomic) IBOutlet UILabel *goTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *AlltimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *item1Label;
@property (strong, nonatomic) IBOutlet UILabel *countName;
@property (strong, nonatomic) IBOutlet UILabel *scanslabel;
- (IBAction)beginBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnName;
@property (strong, nonatomic) IBOutlet UILabel *countscanlabel;

@end
