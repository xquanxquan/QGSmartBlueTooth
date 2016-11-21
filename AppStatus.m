//
//  AppStatus.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/10/24.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "AppStatus.h"

@interface AppStatus ()

@end

@implementation AppStatus
@synthesize contextStr=_contextStr;
static AppStatus *_instance=nil;
+(instancetype)shareInstance;
{
    if (_instance==nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
