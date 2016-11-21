//
//  QGSportMenuController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/11/15.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGSportMenuController.h"

@interface QGSportMenuController ()

@end

@implementation QGSportMenuController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_SportShowData[dataIndex] count];
    }

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * SportMuneCell;
    QGMenuTableViewCell *cell;
    
    if (dataIndex==2) {
        SportMuneCell=[_SportShowTableView dequeueReusableCellWithIdentifier:@"menuSportCell2"];
        SportMuneCell.detailTextLabel.text=@"1";

    }
    else if (dataIndex==1) {
        cell=[_SportShowTableView dequeueReusableCellWithIdentifier:@"SportSettingCell"];
        cell.SportItem.text=[_SportShowData[dataIndex][indexPath.row] objectForKey:@"name"];
        cell.Count_Name.text=[_SportShowData[dataIndex][indexPath.row] objectForKey:@"countName"];
        if (indexPath.row<_SportTarget.count) {
            cell.InputData.text=_SportTarget[indexPath.row];

        }
        cell.InputData.delegate=self;
        cell.InputData.enabled=NO;
  
    }else{
        SportMuneCell=[_SportShowTableView dequeueReusableCellWithIdentifier:@"SportMuneCell"];

    }
        SportMuneCell.textLabel.text=_SportShowData[dataIndex][indexPath.row];
    if (dataIndex==1) {
        return cell;
    }
    return SportMuneCell;
}

- (void)viewDidLoad {
    _SportTarget=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *dic=[self getData:@"SportTarget.json"];
    if (dic!=nil) {
        if ([dic objectForKey: @"mileage" ]) {
            [_SportTarget addObject:[dic objectForKey: @"mileage" ]];

        }
        if ([dic objectForKey: @"speed" ]) {
            [_SportTarget addObject:[dic objectForKey: @"speed" ]];
            
        }
        if ([dic objectForKey: @"walk" ]) {
            [_SportTarget addObject:[dic objectForKey: @"walk" ]];
            
        }
    
    }


    _SportShowTableView.delegate=self;
    _SportShowTableView.dataSource=self;
    _SportShowData=[[NSMutableArray alloc]init];

//    [_SportShowData addObject:@[@"静息心里测试",@"Cooper测试",@"Rockport测试",@"体位性心律测试"]];
       [_SportShowData addObject:@[@"Cooper测试"]];

    [_SportShowData addObject:@[@{@"name":@"运动距离",@"countName":@"米"},@{@"name":@"运动配速",@"countName":@"km/h"},@{@"name":@"运动步数",@"countName":@"步"}]];
    [_SportShowData addObject:@[@"设定走路模式",@"设定跑步模式"]];

    
    dataIndex=0;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QGMenuTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];

    if ([cell.reuseIdentifier isEqualToString:@"SportSettingCell"]) {
        cell.InputData.enabled=YES;
        
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    QGMenuTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];

    [self movedown];
    if ([cell.reuseIdentifier isEqualToString:@"SportSettingCell"]) {

    cell.InputData.enabled=NO;
        NSMutableDictionary *dic=[self getData:@"SportTarget.json"];//读取数据
        if ([cell.SportItem.text isEqualToString:@"运动距离"]) {//添加数据
            [dic setValue:cell.InputData.text forKey:@"mileage"];
            

        }else if([cell.SportItem.text isEqualToString:@"运动配速"]){
            [dic setValue:cell.InputData.text forKey:@"speed"];

        }
        else if([cell.SportItem.text isEqualToString:@"运动步数"]){
            [dic setValue:cell.InputData.text forKey:@"walk"];
            
        }
        //写入数据
        [self writeData:dic name:@"SportTarget.json"];
    NSLog(@"离开了");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-DataDeal
-(NSMutableDictionary *)getData :(NSString *)name{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    QGFileManager *mgn=[[QGFileManager alloc]init];
    AppStatus *usrInfo=[AppStatus shareInstance];
    NSString *path=[mgn pathCreate:usrInfo.contextStr second:name];
    
    NSData *data=[NSData dataWithContentsOfFile:path];
    if (data!=nil) {
       dic= [mgn readjson:data];

    }
    return dic;
    
    
}
-(void)writeData :(NSMutableDictionary *)dic name:(NSString *)name{
    
    QGFileManager *mgn=[[QGFileManager alloc]init];
    AppStatus *usrInfo=[AppStatus shareInstance];
    NSString *path=[mgn pathCreate:usrInfo.contextStr second:name];
    [[mgn getJsonData:dic] writeToFile:path atomically:YES
     ];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-texfiledelagate
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self movedown];
  
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField     // return NO to disallow editing.

{
    [self moveup];

    return YES;
}
#pragma mark-屏幕移动
-(void)moveup{
    if (keyBoardTag==NO) {
        [UIView beginAnimations:@"Animation" context:nil];
        //设置动画的间隔时间
        [UIView setAnimationDuration:0.20];
        //??使用当前正在运行的状态开始下一段动画
        [UIView setAnimationBeginsFromCurrentState: YES];
        //设置视图移动的位移
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 230, self.view.frame.size.width, self.view.frame.size.height);
        //设置动画结束
        [UIView commitAnimations];
        keyBoardTag=YES;
    }
}
-(void)movedown{
    if (keyBoardTag==YES) {
            [UIView beginAnimations:@"Animation" context:nil];
            //设置动画的间隔时间
            [UIView setAnimationDuration:0.20];
            //??使用当前正在运行的状态开始下一段动画
            [UIView setAnimationBeginsFromCurrentState: YES];
            //设置视图移动的位移
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 230, self.view.frame.size.width, self.view.frame.size.height);
            //设置动画结束
            [UIView commitAnimations];
            keyBoardTag=NO;
        
        
    }
}
- (IBAction)selectionShowButton:(id)sender {
    if([sender selectedSegmentIndex]==0){
        dataIndex=0;
    }  else if([sender selectedSegmentIndex]==1){
        dataIndex=1;
    }else
        
    if([sender selectedSegmentIndex]==2){
        dataIndex=2;
    }
    [_SportShowTableView reloadData ];
}
- (IBAction)beginSportBtn:(id)sender {
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        keyBoardTag=NO;
  
}
#pragma mark keyboardSetting

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {           // called when 'return' key  pressed. return NO to ignore.{
    
    QGMenuTableViewCell*cell=[self.SportShowTableView cellForRowAtIndexPath:_SportShowTableView.indexPathForSelectedRow];
    
    if ([cell.reuseIdentifier isEqualToString:@"SportSettingCell"]) {
        
        cell.InputData.enabled=NO;
        NSMutableDictionary *dic=[self getData:@"SportTarget.json"];//读取数据
        if ([cell.SportItem.text isEqualToString:@"运动距离"]) {//添加数据
            [dic setValue:cell.InputData.text forKey:@"mileage"];
            
        }else if([cell.SportItem.text isEqualToString:@"运动配速"]){
            [dic setValue:cell.InputData.text forKey:@"speed"];
            
        }
        else if([cell.SportItem.text isEqualToString:@"运动步数"]){
            [dic setValue:cell.InputData.text forKey:@"walk"];
            
        }
    
        //写入数据
        [self writeData:dic name:@"SportTarget.json"];
    }
    if (keyBoardTag==YES) {
        [UIView beginAnimations:@"Animation" context:nil];
        //设置动画的间隔时间
        [UIView setAnimationDuration:0.20];
        //??使用当前正在运行的状态开始下一段动画
        [UIView setAnimationBeginsFromCurrentState: YES];
        //设置视图移动的位移
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +230, self.view.frame.size.width, self.view.frame.size.height);
        //设置动画结束
        [UIView commitAnimations];
        keyBoardTag=NO;
    }
    [textField resignFirstResponder];
    return YES;
}
@end
