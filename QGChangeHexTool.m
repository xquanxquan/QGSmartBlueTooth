//
//  QGChangeHexTool.m
//  QGSmartBlueTooth
//
//  Created by quan quan on 16/8/8.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGChangeHexTool.h"

@implementation QGChangeHexTool
+(int )convertDataToHexIntForHeartRate:(NSData *)data {
    
    __block int result=0;
    
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        if (dataBytes[0]==0x04) {
            
        }else if(dataBytes[0]==0x06){
            result=dataBytes[1];
            
        }
        
    }];
    
    return result;
}
+ (int )convertDataToHexIntForHeartRateSOMIC:(NSData *)data {
    __block int result=0;
    
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;

            result=dataBytes[2];
            
        
        
    }];
    
    return result;
    
}
+ (int )convertDataToHexIntForStepSOMIC:(NSData *)data {
    __block int result=0;
    
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        result=dataBytes[2]+256*dataBytes[3];
        
        
        
    }];
    
    return result;
}
+ (int )convertDataToHexIntForBarttery:(NSData *)data {
    __block int result=0;
    
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        
        
        result=dataBytes[0];
        
        
        
    }];
    
    return result;
}
+ (NSString * )convertDataToHexIntForSpeed:(NSData *)data {
    __block NSString * result=0;
    __block double x=0;
 
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        unsigned char *dataBytes = (unsigned char*)bytes;
        
        x=dataBytes[1]/256.0+dataBytes[2];
        

        result=[NSString stringWithFormat:@"%0.2f",x];
        
        
        
    }];
    
    return result;
}
+ (NSString * )convertDataToHexIntForSpeedArray:(NSData *)data {
    __block NSString *string= [[NSString alloc]init]; ;
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (int i=1; i<4; i++) {
            string=[string stringByAppendingString:[NSString stringWithFormat:@"%d ",dataBytes[i]]];
    

        }
        
       
        
    }];
    return string;
}
+ (NSString * )convertDataToHexIntForSpeedSOMIC:(NSData *)data//测试数据用
{
    __block NSString *string= [[NSString alloc]init]; ;
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (int i=1; i<4; i++) {
            string=[string stringByAppendingString:[NSString stringWithFormat:@"%d ",dataBytes[i]]];
            
            
        }
        
        
        
    }];
    return string;
}
+ (NSString* )convertDataToHexIntForall:(NSData *)data {
    __block NSString *result=[[NSString alloc]init];
  
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        unsigned char *dataBytes = (unsigned char*)bytes;

        if ( byteRange.length<5) {
            //仅仅jabra适用
        
            for (  int i=0;i<byteRange.length;i++) {
                if (i<byteRange.length+1) {
                    result=[result stringByAppendingString:[NSString stringWithFormat:@"%02d ",dataBytes[i]] ];
                    
                }
                else{
                    result=[result stringByAppendingString:[NSString stringWithFormat:@"%02d",dataBytes[i]] ];
                    
                }
            }
        }
        else{
            NSString *value = [NSString stringWithUTF8String:bytes];
            result=[result stringByAppendingFormat:@"%@", value ?:data];
        }
   
        
//        
//        if (byteRange.length>0) {
//            if (byteRange.length == 1) {
//                
//                for (  int i;i<byteRange.length;i++) {
//                    if (i<byteRange.length+1) {
//                        result=[result stringByAppendingString:[NSString stringWithFormat:@"%02d ",dataBytes[i]] ];
//                        
//                    }
//                    else{
//                        result=[result stringByAppendingString:[NSString stringWithFormat:@"%02d",dataBytes[i]] ];
//                        
//                    }
//                }
//            }
//            else {
//                NSString *value = [NSString stringWithUTF8String:bytes];
//                result = [result stringByAppendingFormat:@"%@", value ?:data];
//            }
//
//        }
//
      
        
        
        
    }];
  
    return result;
}
@end
