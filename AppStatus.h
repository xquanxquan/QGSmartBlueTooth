//
//  AppStatus.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/10/24.
//  Copyright © 2016年 田家赫. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AppStatus : NSObject

@property(nonatomic,retain)NSString *contextStr;

+(instancetype)shareInstance;
@end
