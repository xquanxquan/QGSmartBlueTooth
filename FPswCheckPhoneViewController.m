//
//  FPswCheckPhoneViewController.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/13.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "FPswCheckPhoneViewController.h"
#import "FPswResetViewController.h"
@interface FPswCheckPhoneViewController ()

@end
@implementation FPswCheckPhoneViewController
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    verifyR = NO;
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetVerifyCode:(id)sender {
    NSString *Tips=nil;
    QGCheckTool *CKRigist = [[QGCheckTool alloc]init];
    QGFileManager *fileMng=[[QGFileManager alloc]init];
    NSString *path=[fileMng pathCreate:nil second:@"regist.json"];
    NSLog(@"文件路径：%@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray * dicRoot = [[NSMutableArray alloc]init];
    if (data !=nil) {
        dicRoot=[fileMng readjson:data];
        for (NSDictionary *dic in dicRoot)
        {
            Tips=[CKRigist CheckUsrName:_UserPhone.text NSDic:dic];
        }
        if (Tips)
        {
            verifyR = YES;
        }
        else{
            [self showAlert:@"用户未注册，请先注册"];
        }
        if (verifyR) {
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
                         Tips = [NSString stringWithFormat:@"%@",error];
                         if (Tips) {
                             [self showAlert:Tips];
                         }
                     }}];
        }
    }
    
   
}

- (IBAction)NextStep:(id)sender {
    [SMSSDK commitVerificationCode:_VerifyCode.text phoneNumber:_UserPhone.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        {
            if (!error)
            {
                NSLog(@"验证成功");
                verifySC = YES;
                if (verifySC ==YES) {
                    //属性传值
                    AppStatus *userid = [AppStatus shareInstance];
                    userid.contextStr = _UserPhone.text;
                    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    FPswResetViewController *FP=[main instantiateViewControllerWithIdentifier:@"FPResetPsw"];
                    [FP setValue:_UserPhone.text forKey:@"UserPhone"];
                    [self presentViewController:FP animated:YES completion:^{}];
                }
            }
            else
            {
                NSLog(@"错误信息:%@",error);
            }
        }
    }];

}
- (void)showAlert:(NSString *)str {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    //    [alertV show];
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
