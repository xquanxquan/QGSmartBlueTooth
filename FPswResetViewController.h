//
//  FPswResetViewController.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/13.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStatus.h"
#import "QGCheckTool.h"
#import "QGFileManager.h"
@interface FPswResetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *UserPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *UserPsw;
@property (weak, nonatomic) IBOutlet UITextField *RPUserPsw;
@property (nonatomic,strong) NSString *UserPhone;
@end
