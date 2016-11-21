//
//  QGBlueToothTool.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGBlueToothTool.h"
@implementation QGBlueToothTool


+ (NSString *)properties:(CBCharacteristicProperties)properties separator:(NSString *)separator {
    NSMutableString *desc = [NSMutableString string];
    separator = separator?:@"";
    if (properties & CBCharacteristicPropertyBroadcast) {
        [desc appendFormat:@"%@广播", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyRead) {
        [desc appendFormat:@"%@可读", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [desc appendFormat:@"%@写无回复", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyWrite) {
        [desc appendFormat:@"%@可写", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyNotify) {
        [desc appendFormat:@"%@通知", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyIndicate) {
        [desc appendFormat:@"%@声明", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [desc appendFormat:@"%@写带签名", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyExtendedProperties) {
        [desc appendFormat:@"%@拓展", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyNotifyEncryptionRequired) {
        [desc appendFormat:@"%@加密通知", desc.length ? separator : @""];
    }
    if (properties & CBCharacteristicPropertyIndicateEncryptionRequired) {
        [desc appendFormat:@"%@加密声明", desc.length ? separator : @""];
    }
    return desc;
}
+ (NSMutableArray * )getValue:(CBCharacteristicProperties)properties{
    NSMutableArray *array=[[NSMutableArray alloc]init];

    if (properties & CBCharacteristicPropertyBroadcast) {
        [array addObject:@1];
    }
    if (properties & CBCharacteristicPropertyRead) {
          [array addObject:@2];
    }
    if (properties & CBCharacteristicPropertyWriteWithoutResponse) {
         [array addObject:@4];
    }
    if (properties & CBCharacteristicPropertyWrite) {
           [array addObject:@8];
    }
    if (properties & CBCharacteristicPropertyNotify) {
          [array addObject:@16];
    }
    if (properties & CBCharacteristicPropertyIndicate) {
        [array addObject:@32];
    }
    if (properties & CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [array addObject:@64];
    }
    if (properties & CBCharacteristicPropertyExtendedProperties) {
          [array addObject:@128];
    }
    if (properties & CBCharacteristicPropertyNotifyEncryptionRequired) {
          [array addObject:@160];
    }
    if (properties & CBCharacteristicPropertyIndicateEncryptionRequired) {
          [array addObject:@320];
    }
    return array;
}
@end
