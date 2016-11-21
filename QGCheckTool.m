//
//  CheckRigist.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/2.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "QGCheckTool.h"

@implementation QGCheckTool
-(NSString *) CheckNumLength :(NSString*) PhoneNum {
    NSString *Tips = nil;
    if (PhoneNum.length == 11) {
        if (!([PhoneNum hasPrefix:@"13"] || [PhoneNum hasPrefix:@"15"] || [PhoneNum hasPrefix:@"17"] || [PhoneNum hasPrefix:@"18"])) {
            Tips = @"手机号格式不正确";
        }
    } else {
        Tips = @"请填写11位手机号";
    }
    return Tips;
}

-(NSString *)CheckPsw : (NSString*)Pwd setRepeatPsw : (NSString*)RePwd{
    NSString *Tips = nil;
    if (Pwd.length > 5 && Pwd.length < 13) {
        if (![Pwd isEqualToString:RePwd]) {
            Tips = @"两次密码不一致";
        }
    } else {
        Tips = @"密码长度应在6-12位";
    }
    return Tips;
}
-(NSString *)CheckUsrName:(NSString*)UserName NSDic:(NSDictionary*)dic{
    NSString *Tips = nil;
    if ([[dic objectForKey:@"username"]isEqualToString:UserName])
    {
        Tips = @"用户名已经存在";
    }
    return Tips;
}
@end
