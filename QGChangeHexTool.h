//
//  QGChangeHexTool.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGChangeHexTool : NSObject
+ (int )convertDataToHexIntForHeartRate:(NSData *)data ;
+ (int )convertDataToHexIntForBarttery:(NSData *)data ;
+ (NSString* )convertDataToHexIntForSpeed:(NSData *)data ;
+ (NSString* )convertDataToHexIntForall:(NSData *)data;
+ (NSString * )convertDataToHexIntForSpeedArray:(NSData *)data;//测试数据用
+ (NSString * )convertDataToHexIntForSpeedSOMIC:(NSData *)data;//测试数据用
+ (int )convertDataToHexIntForHeartRateSOMIC:(NSData *)data ;
+ (int )convertDataToHexIntForStepSOMIC:(NSData *)data ;

@end
