//
//  VerifyViewController.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/9.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "VerifyViewController.h"
#import "QGRegistViewController.h"
@interface VerifyViewController ()

@end

@implementation VerifyViewController
#pragma  mark UItextFileDegate
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_UserPhone resignFirstResponder];
    [_VerifyCode resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    verifySC =NO;
    verifyR=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetVerifyCode:(id)sender {
    NSString *Tips=nil;
    QGCheckTool *CKRigist = [[QGCheckTool alloc]init];
    QGFileManager *fileMng=[[QGFileManager alloc]init];
    if (![_UserPhone.text isEqualToString:@""]) {
        NSString *path=[fileMng pathCreate:nil second:@"regist.json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSMutableArray * dicRoot = [[NSMutableArray alloc]init];
        if (data !=nil) {
            dicRoot=[fileMng readjson:data];
            for (NSDictionary *dic in dicRoot)
            {
                Tips=[CKRigist CheckUsrName:_UserPhone.text NSDic:dic];
                if (Tips)
                {
                    verifyR = YES;
                    [self showAlert:Tips];
                    return;
                }
                
            }
            
            
        }
        [self sendSMS];
    }
    else{
        Tips=@"请输入手机号";
        [self showAlert:Tips];

    }

}
-(void)sendSMS{
    if (!verifyR) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_UserPhone.text zone:@"86" customIdentifier:nil result:^(NSError *error)
         {
             NSString *Tips=nil;
             if (!error) {
                 NSLog(@"获取验证码成功");
                 Tips=@"获取验证码成功";
                 if (Tips) {
                     [self showAlert:Tips];
                 }
             } else {
                 NSLog(@"错误信息：%@",error);
                 Tips = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]];
                 if (Tips) {
                     [self showAlert:Tips];
                 }
             }}];
    }
}
- (IBAction)RegistNextVC:(id)sender {
    if (![_VerifyCode.text isEqualToString:@""]&&![_UserPhone.text isEqualToString:@""]) {
        [SMSSDK commitVerificationCode:_VerifyCode.text phoneNumber:_UserPhone.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            
            {
                if (!error)
                {
                    NSLog(@"验证成功");
                    verifySC = YES;
                    if (verifySC ==YES) {
                        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        QGRegistViewController *RC=[main instantiateViewControllerWithIdentifier:@"Regist"];
                        [RC setValue:_UserPhone.text forKey:@"UserPhoneNum"];
                        [self presentViewController:RC animated:YES completion:^{
                            NSLog(@"跳转到注册页面");
                        }];
                        
                    }
                    
                    
                }
                else
                {
                    [self showAlert: [NSString stringWithFormat:@"%@",error.userInfo]];
                }
            }
        }];
    }
    else{
        [self showAlert: @"帐号或者验证码不能为空"];

    }
    

    

}

- (void)showAlert:(NSString *)str {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //    [alertV show];
}

#pragma mark - Navigation




@end
