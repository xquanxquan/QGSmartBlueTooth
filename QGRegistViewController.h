//
//  RegistViewController.h
//  LoginDemo_v1
//
//  Created by 田家赫 on 16/9/27.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFileManager.h"
#import "QGCheckTool.h"

@interface QGRegistViewController : UIViewController
//用户名
//@property (weak, nonatomic) IBOutlet UITextField *UserName;
//密码
//@property (weak, nonatomic) IBOutlet UITextField *PassWord;
//验证码
//@property (weak, nonatomic) IBOutlet UITextField *VCode;
//获取验证码
//@property (weak, nonatomic) IBOutlet UIButton *GetVCode;
//注册按钮
//@property (weak, nonatomic) IBOutlet UIButton *Regist;
//@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserName;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UITextField *RepeatPsw;
@property (weak, nonatomic) IBOutlet UIButton *Regist;
@property (nonatomic,strong) NSString *UserPhoneNum;




@end
