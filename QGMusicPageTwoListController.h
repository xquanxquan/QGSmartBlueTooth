//
//  QGMusicPageTwoListController.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFileManager.h"
#import "QGMusicPlayMusicPlayManager.h"
#import "QGMusicPageTwoCell.h"
@interface QGMusicPageTwoListController : UITableViewController
@property (nonatomic,strong)NSMutableArray *inputArray;
@property (nonatomic,strong)NSMutableArray *itemsArray;
@property (nonatomic,strong)NSMutableArray *loveArray;
@property (nonatomic,strong)NSMutableArray *nearArray;
@property(nonatomic,strong)NSString * MusicTitle;
@end
