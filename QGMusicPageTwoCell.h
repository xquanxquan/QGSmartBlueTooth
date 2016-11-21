//
//  QGMusicPageTwoCell.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/13.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^blockButton)(UIButton *button);
@interface QGMusicPageTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *music_title;
@property (weak, nonatomic) IBOutlet UILabel *music_author;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (strong,nonatomic) blockButton button1;
- (IBAction)love:(id)sender;

@end
