//
//  VerifyLoginViewController.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/13.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFileManager.h"
#import "QGCheckTool.h"
#import "AppStatus.h"
#import <SMS_SDK/SMSSDK.h>
@interface VerifyLoginViewController : UIViewController{
BOOL verifySC;
    BOOL verifyR;}
@property (weak, nonatomic) IBOutlet UITextField *UserPhone;
@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;

@end
