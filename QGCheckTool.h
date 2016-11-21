//
//  CheckRigist.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/2.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGCheckTool : NSObject
-(NSString *) CheckNumLength :(NSString*) PhoneNum;
-(NSString *)CheckPsw : (NSString*)Pwd setRepeatPsw : (NSString*)RePwd;
-(NSString *)CheckUsrName:(NSString*)UserName NSDic:(NSDictionary*)dic;
@end
