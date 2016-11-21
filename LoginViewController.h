//
//  LoginViewController.h
//  QGSmartBlueTooth
//
//  Created by 田家赫 on 2016/11/18.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCViewController.h"
#import "QGFileManager.h"
#import "QGCheckTool.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface LoginViewController : UIViewController<UITextFieldDelegate>
//账号
@property (weak, nonatomic) IBOutlet UITextField *UserName;
//密码
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
//登陆
@property (weak, nonatomic) IBOutlet UIButton *Login;
//FaceBook登录按钮
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLoginButton;

@end
