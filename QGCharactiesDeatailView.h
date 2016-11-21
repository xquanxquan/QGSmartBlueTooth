//
//  QGCharactiesDeatailView.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreBluetooth/CoreBluetooth.h>
#import "QGBlueToothTool.h"
#import "QGCharacteristicCell.h"
#import "QGSportMainController.h"
#import "QGATGATTTool.h"
#import "QGChangeHexTool.h"
typedef void __block(^passValue1)(CBCharacteristic *chr,int i);
@interface QGCharactiesDeatailView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *chrTbaleview;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) CBCharacteristic *getChrS;
@property (strong, nonatomic) passValue1 BToC;
- (IBAction)shareAction:(id)sender;
@property (strong,nonatomic)NSMutableArray *dataValue;
@property (strong,nonatomic)NSMutableArray *showData;//测试数据用的

@end
