//
//  VerifyViewController.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/9.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGCheckTool.h"
#import <SMS_SDK/SMSSDK.h>
#import "QGFileManager.h"
#import "AppStatus.h"
@interface VerifyViewController : UIViewController{
    BOOL verifySC;
    BOOL verifyR;
}
@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;
@property (weak, nonatomic) IBOutlet UITextField *UserPhone;
@end
