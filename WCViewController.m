//
//  WCViewController.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 16/10/10.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "WCViewController.h"
#import "AppStatus.h"
@interface WCViewController ()

@end

@implementation WCViewController
#pragma  mark UItextFileDegate

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userage resignFirstResponder];
    [_usersex resignFirstResponder];
    [_nickename resignFirstResponder];
    [_userhight resignFirstResponder];
    [_userweight resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //        NSLog(@"json文件读取：%@",dicRoot);
    //从本地json文件中加载可用的信息
    NSMutableDictionary * dicRoot=[self readFile];
    _nickename.text = [dicRoot objectForKey:@"usrnickname"];
    _userage.text =[dicRoot objectForKey:@"usrage"];
    if ([[dicRoot objectForKey:@"usrsex"] isEqualToString:@"male"]) {
        _usersex.text =@"男";
    }
    else if ([[dicRoot objectForKey:@"usrsex"] isEqualToString:@"female"]){
        _usersex.text =@"女";
    }
    _userweight.text=[dicRoot objectForKey:@"usrweight"];
    _userhight.text=[dicRoot objectForKey:@"usrhight"];
    // Do any additional setup after loading the view.
    
}
-(NSMutableDictionary *)readFile{
    _userid = [AppStatus shareInstance];
    _userinfo = _userid.contextStr;
    NSMutableDictionary * dicRoot=[[NSMutableDictionary alloc]init];;
    QGFileManager *fileMng=[[QGFileManager alloc]init];
    if (_userinfo !=nil) {
        //获取目录
        //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *documentsDirectory = [paths objectAtIndex:0];
        //
        //        NSString *UserInfoDictionary = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,_userinfo,@"UserInfo.json"];
        
        _UserInfoPath = [fileMng pathCreate:_userinfo second:@"UserInfo.json"];
        //读取文件
        NSData* data = [NSData dataWithContentsOfFile:_UserInfoPath];
         dicRoot = [[NSMutableDictionary alloc]init];
        
        if (data!=nil) {
            dicRoot=[fileMng readjson:data];
        }

    }
    else{
        //跳过情况下的加载
    }
    return dicRoot;
    
}
- (IBAction)UserInfoContinue:(id)sender {
 
        
        
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        QGMainTabBarController *RC=main.instantiateInitialViewController;
    NSMutableDictionary *dic=[self readFile];
 
        [dic setValue:@"" forKey:@"usrage"];
    [dic setValue:_usersex.text forKey:@"usrsex"];
    [dic setValue:_nickename.text forKey:@"usrnickname"];
    [dic setValue:_userweight.text forKey:@"usrweight"];
    [dic setValue:_userhight.text forKey:@"usrhight"];
  
    QGFileManager *qgmgn=[[QGFileManager alloc]init];
    [[qgmgn getJsonData:dic] writeToFile:[qgmgn pathCreate:_userid.contextStr second:@"UserInfo.json"] atomically:YES];

        [self presentViewController:RC animated:YES completion:^{
            
            NSLog(@"跳转到注册页面");
        }];
    
        
        

    
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
