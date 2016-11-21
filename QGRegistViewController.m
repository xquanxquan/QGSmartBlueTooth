//
//  RegistViewController.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 16/9/27.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "QGRegistViewController.h"
#import "LoginViewController.h"
#import "LoginMainViewController.h"
@interface QGRegistViewController ()

@end

@implementation QGRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      _UserName.text = self.UserPhoneNum;
    NSLog(@"%@",_UserPhoneNum);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}
#pragma mark- 注册
- (IBAction)RegisterCompleteAction:(id)sender {
    NSString *Tips = nil;
    NSString *UserNameNum = _UserName.text;
    
    //校验手机号是否符合
    QGCheckTool *CKRigist = [[QGCheckTool alloc]init];
    Tips = [CKRigist CheckNumLength:UserNameNum];
    if (Tips) {
        [self showAlert:Tips];
    }
    
    //校验两次密码是否一致
    NSString *pwd = _PassWord.text;
    NSString *RePwd =_RepeatPsw.text;
    Tips = [CKRigist CheckPsw:pwd setRepeatPsw:RePwd];
    if (Tips) {
        [self showAlert:Tips];
    }
    //校验用户名是否已存在
    QGFileManager *fileMng=[[QGFileManager alloc]init];
   NSString *path=[fileMng pathCreate:nil second:@"regist.json"];
    NSLog(@"文件路径：%@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray * dicRoot = [[NSMutableArray alloc]init];
    if (data !=nil) {
        dicRoot=[fileMng readjson:data];
        for (NSDictionary *dic in dicRoot)
        {
            Tips=[CKRigist CheckUsrName:_UserName.text NSDic:dic];
            if (Tips)
            {
                [self showAlert:Tips];
                return;
            }
        }
    }
    //将用户输入的转换成json后进行存储
    [dicRoot addObject:@{@"username" :_UserName.text,@"password" :_PassWord.text}];
    NSData *jsonData = [fileMng getJsonData:dicRoot];
    //调用获取路径
    [jsonData writeToFile:path atomically:YES];
    Tips = @"注册成功";
    if (Tips)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginMainViewController *VC=main.instantiateInitialViewController;
        [self presentViewController:VC animated:YES completion:^{
            [self showAlert:Tips];
}];
    }
    

}
//
- (void)showAlert:(NSString *)str {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
//    [alertV show];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
