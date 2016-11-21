//
//  HealthTest.m
//  LoginDemo_v1
//
//  Created by 田家赫 on 2016/11/19.
//  Copyright © 2016年 田家赫. All rights reserved.
//

#import "QGHealthTestTool.h"

@implementation QGHealthTestTool
-(NSString*)CooperTest:(NSString*)UserSex Length:(int)Length UserAge:(int)usrage{
    NSString* Tips = nil;
   
    if ([UserSex isEqualToString:@"male"]) {
        if (usrage>=13 &&usrage<=14) {
            if (Length>2700) {
                Tips=@"Verygood";
            }else if (Length<=2700 &&Length>2400){
                Tips=@"Good";
            }else if (Length<=2400 &&Length>2200){
                Tips=@"Average";
            }else if (Length<=2200 &&Length>2100){
                Tips=@"Bad";
            }else if (Length<=2100){
                Tips=@"VeryBad";
        }
        }else if (usrage>=15 &&usrage<=16){
            if (Length>2800) {
                Tips=@"Verygood";
            }else if (Length<=2800 &&Length>2500){
                Tips=@"Good";
            }else if (Length<=2500 &&Length>2300){
                Tips=@"Average";
            }else if (Length<=2300 &&Length>2200){
                Tips=@"Bad";
            }else if (Length<=2200){
                Tips=@"VeryBad";
        }
        }else if (usrage>=17 &&usrage<=19){
            if (Length>3000) {
                Tips=@"Verygood";
            }else if (Length<=3000 &&Length>2700){
                Tips=@"Good";
            }else if (Length<=2700 &&Length>2500){
                Tips=@"Average";
            }else if (Length<=2500 &&Length>2300){
                Tips=@"Bad";
            }else if (Length<=2300){
                Tips=@"VeryBad";
        }
        }else if (usrage>=20 &&usrage<=29){
            if (Length>2800) {
                Tips=@"Verygood";
            }else if (Length<=2800 &&Length>2400){
                Tips=@"Good";
            }else if (Length<=2400 &&Length>2200){
                Tips=@"Average";
            }else if (Length<=2200 &&Length>1600){
                Tips=@"Bad";
            }else if (Length<=1600){
                Tips=@"VeryBad";
        }
        }else if (usrage>=30 &&usrage<=39){
            if (Length>2700) {
                Tips=@"Verygood";
            }else if (Length<=2700 &&Length>2300){
                Tips=@"Good";
            }else if (Length<=2300 &&Length>1900){
                Tips=@"Average";
            }else if (Length<=1900 &&Length>1500){
                Tips=@"Bad";
            }else if (Length<=1500){
                Tips=@"VeryBad";
        }
        }else if (usrage>=40 &&usrage<=49){
            if (Length>2500) {
                Tips=@"Verygood";
            }else if (Length<=2500 &&Length>2100){
                Tips=@"Good";
            }else if (Length<=2100 &&Length>1700){
                Tips=@"Average";
            }else if (Length<=1700 &&Length>1400){
                Tips=@"Bad";
            }else if (Length<=1400){
                Tips=@"VeryBad";
            }
        }else{
            if (Length>2400) {
                Tips=@"Verygood";
            }else if (Length<=2400 &&Length>2000){
                Tips=@"Good";
            }else if (Length<=2000 &&Length>1600){
                Tips=@"Average";
            }else if (Length<=1600 &&Length>1300){
                Tips=@"Bad";
            }else if (Length<=1300){
                Tips=@"VeryBad";
            }
        }
        }
    else if([UserSex isEqualToString:@"female"]){
        if (usrage>=13 &&usrage<=14) {
            if (Length>2000) {
                Tips=@"Verygood";
            }else if (Length<=2000 &&Length>1900){
                Tips=@"Good";
            }else if (Length<=1900 &&Length>1600){
                Tips=@"Average";
            }else if (Length<=1600 &&Length>1500){
                Tips=@"Bad";
            }else if (Length<=1500){
                Tips=@"VeryBad";
            }
        }else if (usrage>=15 &&usrage<=16){
            if (Length>2100) {
                Tips=@"Verygood";
            }else if (Length<=2100 &&Length>2000){
                Tips=@"Good";
            }else if (Length<=2000 &&Length>1700){
                Tips=@"Average";
            }else if (Length<=1700 &&Length>1600){
                Tips=@"Bad";
            }else if (Length<=1600){
                Tips=@"VeryBad";
            }
        }else if (usrage>=17 &&usrage<=19){
            if (Length>2300) {
                Tips=@"Verygood";
            }else if (Length<=2300 &&Length>2100){
                Tips=@"Good";
            }else if (Length<=2100 &&Length>1800){
                Tips=@"Average";
            }else if (Length<=1800 &&Length>1700){
                Tips=@"Bad";
            }else if (Length<=1700){
                Tips=@"VeryBad";
            }
        }else if (usrage>=20 &&usrage<=29){
            if (Length>2700) {
                Tips=@"Verygood";
            }else if (Length<=2700 &&Length>2200){
                Tips=@"Good";
            }else if (Length<=2200 &&Length>1800){
                Tips=@"Average";
            }else if (Length<=1800 &&Length>1500){
                Tips=@"Bad";
            }else if (Length<=1500){
                Tips=@"VeryBad";
            }
        }else if (usrage>=30 &&usrage<=39){
            if (Length>2500) {
                Tips=@"Verygood";
            }else if (Length<=2500 &&Length>2000){
                Tips=@"Good";
            }else if (Length<=2000 &&Length>1700){
                Tips=@"Average";
            }else if (Length<=1700 &&Length>1400){
                Tips=@"Bad";
            }else if (Length<=1400){
                Tips=@"VeryBad";
            }
        }else if (usrage>=40 &&usrage<=49){
            if (Length>2300) {
                Tips=@"Verygood";
            }else if (Length<=2300 &&Length>1900){
                Tips=@"Good";
            }else if (Length<=1900 &&Length>1500){
                Tips=@"Average";
            }else if (Length<=1500 &&Length>1200){
                Tips=@"Bad";
            }else if (Length<=1200){
                Tips=@"VeryBad";
            }
        }else{
            if (Length>2200) {
                Tips=@"Verygood";
            }else if (Length<=2200 &&Length>1700){
                Tips=@"Good";
            }else if (Length<=1700 &&Length>1400){
                Tips=@"Average";
            }else if (Length<=1400 &&Length>1100){
                Tips=@"Bad";
            }else if (Length<=1100){
                Tips=@"VeryBad";
            }
        }
    }
    return Tips;
    }

@end
