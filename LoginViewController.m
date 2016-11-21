 #import "LoginViewController.h"
#import "WCViewController.h"
#import "AppStatus.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma  mark UItextFileDegate
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_UserName resignFirstResponder];
    [_PassWord resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)viewDidLoad {
    QGFileManager *fileMgn=[[QGFileManager alloc]init];
    //校验手机号是否符合
    //判断是否密码正确
    NSString *path= [fileMgn pathCreate:nil second:@"regist.json"];//所有这样的代码都是从服务器上获取登录验证的代码
    NSLog(@"%@",path);
       [super viewDidLoad];
    _UserName.delegate=self;
    _PassWord.delegate=self;
    [self FacebookskipLogin];//快捷登录
    // Do any additional setup after loading the view.
}

-(void)FacebookskipLogin{
        
        if ([FBSDKAccessToken currentAccessToken]) {
            [self getFaceBookData];
    }
}
-(void)getFaceBookData{
    FBSDKGraphRequest *request=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,email,age_range,gender,locale,verified,picture"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result1,NSError *error){
        //将获取到得值取出
        QGFileManager *fileMng=[[QGFileManager alloc]init];
        NSString *usrid =[result1 objectForKey:@"id"];
        NSString *usrnickname = [result1 objectForKey:@"name"];
        NSString *usrage = [NSString stringWithFormat:@"%@",[[result1 objectForKey:@"age_range"] objectForKey:@"min"]] ;
        NSString *usrgender =[result1 objectForKey:@"gender"];
        //            NSLog(@"用户id:%@",usrid);
        //            NSLog(@"用户昵称：%@",usrnickname);
        //            NSLog(@"用户年龄：%@",usrage);
        //单例传值将userid传至WC页面
        AppStatus *userid = [AppStatus shareInstance];
        userid.contextStr = usrid;
        // 创建目录
        //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //            NSString *documentsDirectory = [paths objectAtIndex:0];
        //
        //            NSLog(@"documentsDirectory%@",documentsDirectory);//获得Documents文件夹目录
        //
        //            NSFileManager *fileManager = [NSFileManager defaultManager];
        //            NSString *UseridDirectory = [documentsDirectory stringByAppendingPathComponent:usrid];
        //            [fileManager createDirectoryAtPath:UseridDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        //创建usrinfo.json文件
        NSString *UserInfoPath =[fileMng pathCreate:usrid second:@"UserInfo.json"];
        //            NSLog(@"%@",UserInfoDictionary);
        //将result1转换格式
        //            NSData* usrdata = [NSData dataWithContentsOfFile:usriddictionary];
        NSData *DATA=[NSData dataWithContentsOfFile:UserInfoPath];
        NSMutableDictionary * dicRoot = [fileMng  readjson:DATA];
        [dicRoot setValue:usrid forKey:@"usrid"];
        [dicRoot setValue:usrnickname forKey:@"usrnickname"];
        
        [dicRoot setValue:usrage forKey:@"usrage"];
        [dicRoot setValue:usrgender forKey:@"usrsex"];
        //            if ([NSJSONSerialization JSONObjectWithData:usrdata options:NSJSONReadingMutableContainers error:nil]!=nil) {
        //                dicRoot=[NSJSONSerialization JSONObjectWithData:usrdata options:NSJSONReadingMutableContainers error:nil];
        //            }
        //将键值对存储到本地
        NSData *jsonData = [fileMng getJsonData:dicRoot];
        [jsonData writeToFile:UserInfoPath atomically:YES];
        //打印userinfo.json文件.
        /*            NSArray *array = [[NSArray alloc]initWithContentsOfFile:UserInfoDictionary];
         
         jsonData =[[NSData alloc] initWithContentsOfFile:UserInfoDictionary];
         if (jsonData!=nil ) {
         array=    [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
         }
         NSLog(@"%@", array);
         //属性传值
         */
    }];
    
    [self gotoNextView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginAction:(id)sender {
    UIAlertView *alertV ;
    NSString *alertTitle = nil;
    NSString *message = nil;
    if (![_UserName.text isEqualToString:@""]&&![_PassWord.text isEqualToString:@""]) {
        QGFileManager *fileMgn=[[QGFileManager alloc]init];
        //校验手机号是否符合
        //判断是否密码正确
        NSString *path= [fileMgn pathCreate:nil second:@"regist.json"];//所有这样的代码都是从服务器上获取登录验证的代码
        NSData* data = [NSData dataWithContentsOfFile:path];
        
        if (data != nil) {
            NSArray* dicRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in dicRoot)
            {
                if ([[dic objectForKey:@"username"]isEqualToString:_UserName.text])
                {
                    if ([[dic objectForKey:@"password"]isEqualToString:_PassWord.text]) {
                        alertTitle = @"登录成功";
                        message = @"2333333";
                        AppStatus *userid = [AppStatus shareInstance];
                        userid.contextStr = _UserName.text;
                        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        WCViewController *WC=[main instantiateViewControllerWithIdentifier:@"welcome"];
                        NSString *creatPath=[fileMgn pathCreate:userid.contextStr second:@"UserInfo.json"];
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                        [dic setValue:userid.contextStr forKey:@"usrid"];
                        [[fileMgn getJsonData:dic] writeToFile:creatPath atomically:YES];
                        
                        [self.navigationController pushViewController:WC animated:YES];
                    }else{
                        alertTitle = @"登录失败";
                        message = @"用户名或密码错误";
                    }
                }
                
            }
            
        }
        else{
            alertTitle = @"登录失败";
            message = @"帐号没有注册请先注册";
        }
   

    }
    else{
        alertTitle = @"登录失败";
        message = @"帐号或密码不能为空";
    }
    if (message) {
        alertV = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertV show];
    }
}
- (IBAction)FBLoginAction:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
   
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self getFaceBookData];

         }
     }];
    
}
#pragma mark-跳转
-(void)gotoNextView{
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    WCViewController *WC=[main instantiateViewControllerWithIdentifier:@"welcome"];
    [self.navigationController pushViewController:WC animated:YES];
}
#pragma mark-弹出框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"登录成功"]) {
    }
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
}


@end
