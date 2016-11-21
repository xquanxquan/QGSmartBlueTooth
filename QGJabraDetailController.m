//
//  jabraDetailController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/7.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGJabraDetailController.h"

@implementation QGJabraDetailController
- (void)viewDidLoad {

    [super viewDidLoad];
}
-(void)getCharactisticValue:(NSNotification *)nti{

}
#pragma mark - Uitableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _datasource.services.count;

//有多少个section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < _datasource.services.count) {
        return _datasource.services[section].characteristics.count;
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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell.textLabel sizeThatFits:CGSizeZero].height + [cell.detailTextLabel sizeThatFits:CGSizeZero].height + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jabraService"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"jabraService"];
    }
    CBCharacteristic *chr=_datasource.services[indexPath.section].characteristics[indexPath.row];
    NSString *desc = [[QGATGATTTool shareInstance] characteristicDesc:chr];
//    NSLog(@"%@",[chr.descriptors valueForKeyPath:@"UUID.UUIDString"]);
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString (desc,@"") ?: @"",NSLocalizedString( desc,@"")?@" : ":@"", chr.UUID.UUIDString];
 
    if ([chr.UUID.UUIDString isEqualToString:CBUUIDCharacteristicUserDescriptionString]) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@|%@",[QGBlueToothTool properties:chr.properties separator:@"|"],chr.value];
    }else{
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@|%@",[QGBlueToothTool properties:chr.properties separator:@"|"],[QGChangeHexTool convertDataToHexIntForall: chr.value]];
    }

    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section==0) {
//
//    
//            return [NSString stringWithFormat:@"%@", _datasource.name];
//    }
    CBService *ser=_datasource.services[section];//    // section
//    CBService *service = self.peripheral.services[section];
//    NSString *desc = [[ATGATTTool shareInstance] serviceDesc:service];
   NSString*str =[NSString  stringWithFormat:@"%@" , ser.UUID ];
    return [NSString stringWithFormat:@"%@ |编号: %@",NSLocalizedString (str,@""),ser.UUID.UUIDString];
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//   
//    _passChr=_datasource.services[indexPath.section].characteristics[indexPath.row];
//}

//高德地图定位时间
#pragma mark-SEGUE
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    _passChr=_datasource.services[indexPath.section].characteristics[indexPath.row];

    if ([segue.identifier isEqualToString:@"charactictisDetail"])
    {
        QGCharactiesDeatailView *DetailVc = segue.destinationViewController;
        [DetailVc setGetChrS:_passChr];
        _passChr=nil;
        [DetailVc setBToC:^(CBCharacteristic *chr,int i){
            _AtoB(chr,i);
            
        }];
        //        [segue2 setValue:title forKey:@"itemTitle"];
        
    }
}


@end
