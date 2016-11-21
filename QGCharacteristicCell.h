//
//  characteristicCell.h
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QGCharacteristicCell : UITableViewCell
typedef void (^clikedBtn)(QGCharacteristicCell * model,UIButton * button);

@property (strong, nonatomic) IBOutlet UIButton *ReadBtn;
@property (strong, nonatomic) IBOutlet UIButton *WriteBtn;
@property (strong, nonatomic) IBOutlet UIButton *RSS;
@property (strong, nonatomic) IBOutlet UILabel *dataValue;
@property (strong, nonatomic) IBOutlet UILabel *valueData;
@property (strong, nonatomic) clikedBtn cki;//button

@end
