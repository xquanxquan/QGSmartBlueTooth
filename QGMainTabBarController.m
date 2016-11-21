//
//  QGMainTabBarController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/10/18.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGMainTabBarController.h"

@interface QGMainTabBarController ()

@end

@implementation QGMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIStoryboard *SportStoryboard=[UIStoryboard storyboardWithName:@"Sport" bundle:nil];
    UIViewController *SportView=[SportStoryboard instantiateViewControllerWithIdentifier:@"SportView"];
    UIStoryboard *MusicStoryboard=[UIStoryboard storyboardWithName:@"Music" bundle:nil];
    UIViewController *MusicView=[MusicStoryboard instantiateViewControllerWithIdentifier:@"MusicView"];
    UIStoryboard *SettingStoryboard=[UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UIViewController *SettingView=[SettingStoryboard instantiateViewControllerWithIdentifier:@"SettingView"];
    // Do any additional setup after loading the view.
    SportView.tabBarItem.title=@"我的运动";
    MusicView.tabBarItem.title=@"我的音乐";
    SettingView.tabBarItem.title=@"个人设置";
    
    [self setViewControllers:@[SportView,MusicView,SettingView] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
