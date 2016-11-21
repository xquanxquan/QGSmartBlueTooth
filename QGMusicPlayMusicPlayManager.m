//
//  QGMusicPlayMusicPlayManager.m
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import "QGMusicPlayMusicPlayManager.h"

@implementation QGMusicPlayMusicPlayManager
-(MPMediaItemCollection*)getLocalMediaItemCollection{//形成总表totalMusic.json，itemsarray数组中已然是刷选出来的dictionary（每个dic都是一首歌的全部信息）
    
    MPMediaQuery *mediaQueue = [MPMediaQuery songsQuery];
    
    return [[MPMediaItemCollection alloc]initWithItems:[mediaQueue.items copy]];//保存所有数据
    
}

-(NSMutableArray *)addArray:(MPMediaItemCollection*)musicCollection{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (MPMediaItem *item in musicCollection.items) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:[NSString stringWithFormat:@"%llu",item.persistentID] forKey:@"music_id"];
        [dic setValue:item.title forKey:@"music_name"];
        [dic  setValue:item.artist forKey:@"music_author"];
        [dic setValue:item.genre forKey:@"music_type"];
        [dic setValue:[NSString stringWithFormat:@"%ld",item.playCount] forKey:@"music_playcount"];
        [dic setValue:@"username" forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)musicClassNormal]  forKey:@"music_class"];
        //uid 指用户的id
        [array  addObject:dic];
    }
    return array;
}//每首歌挑出6个段信息后以dic形式存放到数组中

-(MPMediaItem *)getSongItem:(NSString *)ID songItems:(MPMediaItemCollection*)songCollection{
    
    for (MPMediaItem *item in songCollection.items) {
        if ([ID isEqualToString:[NSString stringWithFormat:@"%llu",item.persistentID]] ) {
            return item;
        }
    }
    return nil;
}//匹配到特定的一首歌

@end
