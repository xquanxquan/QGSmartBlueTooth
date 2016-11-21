//
//  QGFileManager.m
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/14.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGFileManager.h"

@implementation QGFileManager
-(id)getLocalData:(NSString *)path//获取本地文件
{
    return [[NSData alloc]initWithContentsOfFile:path];
    
}
-(NSMutableDictionary *)getUserInfo
{
    return nil;
}


-(NSString *)pathCreate:(NSString *)username second:(NSString *)jsonName{// 获取到路径
    NSFileManager *manager=[[NSFileManager alloc]init];
    NSArray *array1=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[array1 objectAtIndex:0];
    if (username!=nil) {
        path=[path stringByAppendingFormat:@"/%@",username];
        
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
  
    path=[path stringByAppendingFormat:@"/%@",jsonName];
    
    NSLog(@"%@",path);
    return path;
}

-(NSData *)getJsonData:(id)data{//为写入json而转换数据
    
    return [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    
}

-(id)readjson:(NSData*)data
{
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//读取数据
}

-(id)changeJsonData:(NSString *)path forDicValue:(NSMutableDictionary *)value KeyName:(NSString *)name//数组中修改字典数据
{
    NSData *data=[self getLocalData:path];
    id jsonDatas=[self readjson:data];
    for (int i=0;i<[jsonDatas count];i++) {
        if ([[value objectForKey:name] isEqualToString:[jsonDatas[i] objectForKey:name]]) {
            [jsonDatas replaceObjectAtIndex:i withObject:value];
            
        }
    }
    return jsonDatas;
}
//创建文件夹


@end
