//
//  QGMusicPlayMusicPlayManager.h
//  QGSmartBlueTooth
//
//  Created by 习近平 on 16/11/11.
//  Copyright © 2016年 com.gxqhaoren@tom.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
typedef NS_ENUM(NSInteger) {
    musicClassNormal=0,
    musicClassNearPlay=1,
    musicClassLoveMusic=2,
    musicClassOtherList=3
}musicClass;

@interface QGMusicPlayMusicPlayManager : NSObject
-(MPMediaItemCollection *)getLocalMediaItemCollection;//获取全部的音乐资料
-(NSMutableArray *)addArray:(MPMediaItemCollection*)musicCollection;
-(MPMediaItem *)getSongItem:(NSString *)ID songItems:(MPMediaItemCollection*)songCollection;
//从歌单中匹配一个歌曲 然后返回这个歌曲 应该有个参数 这个参数是 歌曲id,如果没有返回nil
@end
