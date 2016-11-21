//
//  FPswResetViewController.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/13.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "FPswResetViewController.h"
#import "LoginViewController.h"
@interface FPswResetViewController ()

@end

@implementation FPswResetViewController
#pragma  mark UItextFileDegate

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_UserPsw resignFirstResponder];
    [_RPUserPsw resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _UserPhoneNum.text = self.UserPhone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)FPswReset:(id)sender {
    NSString *Tips =nil;
    NSString *UserNameNum = self.UserPhone;
    //校验两次密码是否一致
    QGCheckTool *CKRigist = [[QGCheckTool alloc]init];
    NSString *pwd = _UserPsw.text;
    NSString *RePwd =_RPUserPsw.text;
    Tips = [CKRigist CheckPsw:pwd setRepeatPsw:RePwd];
    if (Tips) {
        [self showAlert:Tips];
    }
    
    QGFileManager *fileMng=[[QGFileManager alloc]init];
    NSString *path=[fileMng pathCreate:nil second:@"regist.json"];
    NSLog(@"文件路径：%@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray * dicRoot = [[NSMutableArray alloc]init];
    if (data !=nil) {
        dicRoot=[fileMng readjson:data];
        for (NSDictionary *dic in dicRoot)
        {
            if ([[dic objectForKey:@"username"]isEqualToString:UserNameNum]) {
                [dic setValue:_UserPsw.text forKey:@"password"];
            }
        }
    }
    NSData *jsonData = [fileMng getJsonData:dicRoot];
    //调用获取路径
    [jsonData writeToFile:path atomically:YES];
    Tips = @"密码修改成功，跳转至登陆界面";
    if (Tips)
    {
        [self showAlert:Tips];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *LC=[main instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:LC animated:YES completion:^{}];
    }

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
