//
//  FPswCheckPhoneViewController.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/13.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFileManager.h"
#import "QGCheckTool.h"
#import <SMS_SDK/SMSSDK.h>
#import "AppStatus.h"
@interface FPswCheckPhoneViewController : UIViewController{
    BOOL verifySC;//判断是否验证成功
    BOOL verifyR;//判断是否已经注册

}
@property (weak, nonatomic) IBOutlet UITextField *UserPhone;
@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;

@end
