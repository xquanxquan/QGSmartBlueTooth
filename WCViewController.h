//
//  WCViewController.h
//  QGSmartBlueTooth
//
//  Created by 田家赫 on 2016/11/18.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFileManager.h"
#import "QGMainTabBarController.h"
#import "AppStatus.h"
@interface WCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickename;
@property (weak, nonatomic) IBOutlet UITextField *usersex;
@property (weak, nonatomic) IBOutlet UITextField *userage;
@property (weak, nonatomic) IBOutlet UITextField *userhight;
@property (weak, nonatomic) IBOutlet UITextField *userweight;
@property (nonatomic,strong) NSString *userinfo;
@property (nonatomic,strong) NSString *UserInfoPath;
@property (nonatomic,strong)    AppStatus *userid ;

@end
