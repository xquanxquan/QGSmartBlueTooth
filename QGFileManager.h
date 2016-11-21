//
//  QGFileManager.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/14.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGFileManager : NSObject
-(NSString *)pathCreate:(NSString *)username second:(NSString *)jsonName;//获取路径
-(NSData *)getJsonData:(id)data;  //转换json数据
-(id)readjson:(NSData*)data;
-(id)getLocalData:(NSString *)path;//获取本地文件
-(id)changeJsonData:(NSString *)path forDicValue:(NSMutableDictionary *)value KeyName:(NSString *)name;//数组中修改字典数据
-(NSMutableDictionary *)getUserInfo;//获取用户资料
@end
