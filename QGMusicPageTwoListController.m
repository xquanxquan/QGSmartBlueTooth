//
//  QGMusicPageTwoListController.m
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGMusicPageTwoListController.h"

@interface QGMusicPageTwoListController ()

@end

@implementation QGMusicPageTwoListController

- (void)viewDidLoad {
    if ([_MusicTitle isEqualToString:@"总列表"]) {
        _inputArray =[_itemsArray mutableCopy] ;
    }
    else if([_MusicTitle isEqualToString:@"喜好列表"]){
        _inputArray =[_loveArray mutableCopy];
    }
    else
    {
        _inputArray =[_nearArray mutableCopy];
    }
    
    self.navigationItem.title=_MusicTitle;

    if (_loveArray==nil) {
        _loveArray=[[NSMutableArray alloc]init];
        QGFileManager *FILEmanager=[[QGFileManager alloc]init];
        NSString*path=[[NSString alloc]init];
        NSData *data=[[NSData alloc]init];
        path=[FILEmanager pathCreate: [_inputArray[0] objectForKey:@"uid"]second:@"loveMusic.json"];
        data=[FILEmanager getLocalData:path];
        
        if (data!=nil) {
            NSMutableArray *array=[[NSMutableArray alloc]init];
            array= [FILEmanager readjson:data];
            for (NSMutableDictionary * dic in array) {
                [_loveArray addObject:dic];
            }
        }
    }
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _inputArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGMusicPageTwoCell *cell=[self.tableView   dequeueReusableCellWithIdentifier:@"CELL2"];//将页面2的CELL2同musicDetailTableViewCell文件链接起来
    NSMutableDictionary *dic = _inputArray[indexPath.row];
    cell.music_title.text=[dic objectForKey:@"music_name"]  ;
    cell.music_author.text=[dic objectForKey:@"music_author"] ;
    
    if ([[[_inputArray objectAtIndex:indexPath.row] objectForKey:@"music_class"] intValue]==musicClassNormal)
    {
        [cell.loveButton setBackgroundColor:[UIColor greenColor]];
    }
    else
    {
        [cell.loveButton setBackgroundColor:[UIColor blueColor]];
    }
    
    cell.button1=^(UIButton *button){
        if ([[_inputArray[indexPath.row]objectForKey:@"music_class"] intValue]==musicClassNormal) {
            //添加
            QGFileManager *FILEmanager=[[QGFileManager alloc]init];
            NSString*path=[[NSString alloc]init];
            NSData *data=[[NSData alloc]init];
            
            path=[FILEmanager pathCreate: [dic objectForKey:@"uid"]second:@"loveMusic.json" ];
            
            [_loveArray addObject:_inputArray[indexPath.row]];//注意此时是segue1时刻，即喜好列表并未从页面1传达到页面2，是否喜好数组也要传到？或者说这里最终是形成一个lovemusic.json文件，只需要在本页面有个属性lovearray就行，最终会汇总到json文件中？沙箱中的json文件是存在于app运行的整个生命周期么？
            //获取路径
            //转换数据
            //写入本地文件
            [button setBackgroundColor:[UIColor  blueColor]];//颜色改变
            [_inputArray[indexPath.row] setValue:[NSString stringWithFormat:@"%ld",(long)musicClassLoveMusic] forKey:@"music_class"];
            
            data= [FILEmanager getJsonData:_loveArray];
            if ( [ data writeToFile:path atomically:YES]==YES) {
                NSLog(@"写入成功");
            } else{
                NSLog(@"写入失败");
            }
            button.tag=1;
        }else if ([[_inputArray[indexPath.row]objectForKey:@"music_class"] intValue]==musicClassLoveMusic)
            {
                //删除,同时图片要变化,每次都会生成一个json文件
                [_inputArray[indexPath.row] setValue:[NSString stringWithFormat:@"%ld",(long)musicClassNormal] forKey:@"music_class"];
                //改变 music的值
                [_loveArray removeObject:_inputArray[indexPath.row]];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                dic=_inputArray[indexPath.row];
                if (![self.navigationItem.title isEqualToString:@"总列表"]) {
                    [_inputArray removeObjectAtIndex:indexPath.row];
                }
          
                QGFileManager *FILEmanager=[[QGFileManager alloc]init];
                [[FILEmanager getJsonData:_loveArray] writeToFile:[FILEmanager pathCreate:[dic objectForKey:@"uid"] second:@"loveMusic.json" ]  atomically:YES];
                NSString *path=[FILEmanager pathCreate: [dic objectForKey:@"uid"] second:@"totalMusic.json"] ;
                
                [[FILEmanager  changeJsonData: path forDicValue:dic
                                      KeyName:@"music_id"] writeToFile:path atomically:YES];
                //逻辑上少了对总列表的修改

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                   NSLog(@"%lu", (unsigned long)_inputArray.count);
                });
                button.tag=0;
            }
    };
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath  *indexPath=[self.tableView  indexPathForSelectedRow ];//前面两行识获取当前点击行的代码
    if ([segue.identifier isEqualToString:@"music_item"]) {
        [segue.destinationViewController setValue:_inputArray[indexPath.row] forKey:@"music_item"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
