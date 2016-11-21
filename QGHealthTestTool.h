//
//  HealthTest.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/19.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGFileManager.h"
@interface QGHealthTestTool : NSObject
-(NSString*)CooperTest:(NSString*)UserSex Length:(int)Length UserAge:(int)usrage;
//UserSex:male female
//Length:以米为单位
//usrage:以岁为单位
//返回值:等级:Verygood，good,Average,bad,very bad
@end
