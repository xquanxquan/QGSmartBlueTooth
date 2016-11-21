//
//  jabraDetailController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/7.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreBluetooth/CoreBluetooth.h>
#import "QGBlueToothTool.h"
#import "QGCharactiesDeatailView.h"
#import "QGATGATTTool.h"
//#import "QGChangeHexTool.m"
//typedef void (^DataPass)(NSMutableArray *data);
typedef void __block(^passValue)(CBCharacteristic *chr,int i);
@interface QGJabraDetailController : UITableViewController
@property (strong,nonatomic)passValue AtoB;
@property (nonatomic,strong) CBPeripheral*datasource;
@property (nonatomic,strong) CBCharacteristic* passChr;


@end
