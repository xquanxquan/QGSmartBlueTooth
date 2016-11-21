//
//  QGBlueToothTool.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface QGBlueToothTool : NSObject
+ (NSString *)properties:(CBCharacteristicProperties)properties separator:(NSString *)separator;
+ (NSMutableArray * )getValue:(CBCharacteristicProperties)properties ;
@end