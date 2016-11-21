//
//  QGSettingTableViewController.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/11/14.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGSettingTableViewController.h"

@interface QGSettingTableViewController ()

@end

@implementation QGSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemsArray =@[
  @{@"item":@"个人信息" ,
    @"Value":@[@"查看个人信息",@"修改个人信息"]},
  @{@"item":@"系统设置" ,
    @"Value":@[@"检查更新",@"意见反馈",@"app相关设置",@"语音提醒设置"  ]},
  @{@"item":@"设定运动目标" ,
    @"Value":@[@"设定运动距离",@"设定运动步数",@"设定卡路里消耗",@"设定运动时长"]}
  ];//内容初始化
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemsArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return  [[_itemsArray[section] objectForKey:@"Value"] count];

}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_itemsArray[section] objectForKey:@"item"];
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    cell.textLabel.text=[[_itemsArray[indexPath.section] objectForKey:@"Value"] objectAtIndex:indexPath.row];
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
