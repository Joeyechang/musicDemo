//
//  CZMusicTool.h
//  TT音乐播放器
//
//  Created by chang on 14/12/30.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>



@interface CZMusicTool : NSObject

@property (assign,nonatomic) NSTimeInterval currentTime;
@property (assign,nonatomic) NSTimeInterval duration;
@property (assign,nonatomic) CGFloat progress;
@property (strong,nonatomic) AVAudioPlayer *player;


+(instancetype)sharedInstance;



//是否带参数
//问题一  :应该重新创建播放器来play？or  直接play
//问题二  ：我们要播放的歌曲类型是甚么？  本地？ 在线？ 音效？
//+(BOOL)playWithPath:(NSString *)aPath;

-(BOOL)playWithPath:(NSString *)aPath andType:(kCZMusicType)aType;

//直接播放model
-(BOOL)playWithMusic:(CZMusicModel*)model;

-(BOOL)pause;


@end
