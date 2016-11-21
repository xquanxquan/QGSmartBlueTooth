//
//  QGCharactiesDeatailView.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGCharactiesDeatailView.h"



@implementation QGCharactiesDeatailView
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chrTbaleview reloadData];
}
- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getCHrValue" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCharactistic:) name:@"getCHrValue" object:nil];

    _chrTbaleview.delegate=self;
    _chrTbaleview.dataSource=self;
    _dataValue =[[NSMutableArray alloc]init];
    _showData =[[NSMutableArray alloc]init];

    if (_getChrS.value!=nil) {
        [self setDateSource];

    }
    [super viewDidLoad];
    // Do view setup here.
}
-(void)setDateSource{
    NSString *STR=[[NSString alloc]init];
    STR=[self getTime];
    NSDictionary *dic=@{@"date":STR,@"value":[QGChangeHexTool convertDataToHexIntForall:_getChrS.value]  };
    [_dataValue addObject:dic];
    if ([_getChrS.UUID.UUIDString isEqualToString:@"2A37"]) {
        [_showData addObject:[NSString stringWithFormat:@"%@\t", STR]];
        [_showData addObject: [NSString stringWithFormat:@"%d\n", [QGChangeHexTool convertDataToHexIntForHeartRate:_getChrS.value]  ]];

    }else if([_getChrS.UUID.UUIDString isEqualToString:@"2A53"]){
        [_showData addObject:[NSString stringWithFormat:@"%@\t", STR]];

        [_showData addObject:[NSString stringWithFormat:@"%@\n", [QGChangeHexTool convertDataToHexIntForSpeedArray:_getChrS.value]]] ;

    }else if([_getChrS.UUID.UUIDString isEqualToString:@"FFF2"]){
        [_showData addObject:[NSString stringWithFormat:@"%@\t", STR]];
        
        [_showData addObject:[NSString stringWithFormat:@"%@\n", [QGChangeHexTool convertDataToHexIntForSpeedArray:_getChrS.value]]] ;
        
    }
    else if([_getChrS.UUID.UUIDString isEqualToString:@"FFF3"]){
        [_showData addObject:[NSString stringWithFormat:@"%@\t", STR]];
        
        [_showData addObject:[NSString stringWithFormat:@"%@\n", [QGChangeHexTool convertDataToHexIntForSpeedArray:_getChrS.value]]] ;
        
    }


}
-(void)getCharactistic:(NSNotification *)nti{
    [self setDateSource];


    [self.chrTbaleview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:NO];
    
}


#pragma mark - Uitableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
    
    //有多少个section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }
    else if(section==1){
        if (_dataValue.count<10){
            return _dataValue.count;
        }
        else{
            return 10;
        }
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QGCharacteristicCell *cell =[tableView dequeueReusableCellWithIdentifier:@"chrPropertics"];
;
    return [cell.ReadBtn sizeThatFits:CGSizeZero].height+20;
;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     QGCharacteristicCell *cell ;

    if(indexPath.section==0){

        cell = [tableView dequeueReusableCellWithIdentifier:@"chrPropertics"];
        __weak typeof(QGCharacteristicCell) *weakCell=cell;//

        for (NSNumber* i in [QGBlueToothTool getValue:_getChrS.properties ]) {
            if (i.intValue==2) {
                cell.ReadBtn.hidden=NO;
                [cell.ReadBtn setTitle:@"读取数据" forState:UIControlStateNormal];
            

            }
            if (i.intValue==8) {
                cell.WriteBtn.hidden=NO;
                    [cell.WriteBtn setTitle:@"写数据" forState:UIControlStateNormal];


            }
            if (i.intValue==16) {
                cell.RSS.hidden=NO;
                [cell.RSS setTitle:@"订阅数据" forState:UIControlStateNormal];

             
            }
       
            cell.cki=^(QGCharacteristicCell * model,UIButton *button){
                if ([button.titleLabel.text isEqualToString:@"读取数据"]) {
                    _BToC(_getChrS,1);

              
        
                }
                else if([button.titleLabel.text isEqualToString:@"订阅数据"]){

                            _BToC(_getChrS,2);
                    [weakCell.RSS setTitle:@"取消订阅" forState:UIControlStateNormal];
                    self.navigationItem.rightBarButtonItem.enabled=NO;
                    

                }
                
                
                else if([button.titleLabel.text isEqualToString:@"写入数据"]){
                    NSArray *array=@[_getChrS,@3];
                    [self setNotification:array];
                    
                }else if([button.titleLabel.text isEqualToString:@"取消订阅"]){
                    _BToC(_getChrS,0);
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [weakCell.RSS setTitle:@"订阅数据" forState:UIControlStateNormal];


                }else
                {
                    NSLog(@"未知错误'");
                
                    
                }
            };
        }
    
    
    }
    else{
   
        cell = [tableView dequeueReusableCellWithIdentifier:@"chrValue"];
        cell.valueData.text=[_dataValue[_dataValue.count- indexPath.row-1]objectForKey:@"date"];
        
        cell.dataValue.text=[NSString stringWithFormat:@"%@",   [ _dataValue[_dataValue.count- indexPath.row-1] objectForKey:@"value"]];
     
    }
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {

    //单例传值
        NSString *desc = [[QGATGATTTool shareInstance] characteristicDesc:_getChrS];
        NSLog(@"%@",[[NSBundle mainBundle] localizedStringForKey:desc value:@"" table:nil]);
        return [NSString stringWithFormat:@"%@|属性%@%@",   NSLocalizedString(desc,@"") ?: @"",NSLocalizedString(desc,@"") ?@" : ":@"",[QGBlueToothTool properties:_getChrS.properties separator:@"|"]];
    }
    else if(section==1){
            return [NSString stringWithFormat:@"特征值"];
    }
    return nil;
    
}

#pragma  mark-getTime1
-(NSString *)getTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"hh:mm:ss.SSS"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return  locationString;
}
#pragma mark-POST
-(void)setNotification:(NSArray *)array{
    

}
- (IBAction)back:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
    _BToC(_getChrS,0);
 }
#pragma  mark-SHARE
- (void)share {

    NSString *str=[[NSString alloc]init];
    
    for (NSString * k in _showData) {
        if (k!=nil) {
            str=[str stringByAppendingString:k];

        }
    }
    UIActivityViewController *activityViewController =
    
    [[UIActivityViewController alloc] initWithActivityItems:@[str]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                          }];
}


- (IBAction)shareAction:(id)sender {
  
    [self share];
}
@end
