//
//  QGSportMenuController.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/11/15.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGMenuTableViewCell.h"
#import "QGFileManager.h"
#import "AppStatus.h"
@interface QGSportMenuController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int dataIndex;
    BOOL keyBoardTag;
}
- (IBAction)selectionShowButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *SportShowTableView;
@property(strong,nonatomic)NSMutableArray *SportShowData;
@property(strong,nonatomic)NSMutableArray *SportTarget;

- (IBAction)beginSportBtn:(id)sender;

@end
