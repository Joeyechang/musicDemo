//
//  CZMusicTool.m
//  TT音乐播放器
//
//  Created by chang on 14/12/30.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "CZMusicTool.h"

@implementation CZMusicTool


static CZMusicTool *_INSTANCE;


/**
 *  单例的获取方法
 *
 *  @return 音乐播放工具类的唯一实例
 */
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _INSTANCE=[CZMusicTool new];
        //开启后台播放模式
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    
    return _INSTANCE;
}

/**
 *  重载总时间的get方法
 *
 *  @return <#return value description#>
 */
-(NSTimeInterval)duration
{
    
    if (_player) {
        
        return   [_player duration];
    }
    return 0;


}

/**
 *  重载progress的get方法
 *
 *  @return <#return value description#>
 */
-(CGFloat)progress{
    
    if (_player) {
        return _player.currentTime/_player.duration;
    }
    
    return 0;
}

/**
 *  重载currentTimer get方法
 *
 *
 *
 *  @return <#return value description#>
 */
-(NSTimeInterval)currentTime
{

    if (_player) {
        
        return   [_player currentTime];
    }
    return 0;
}


/**
 *  播放音乐的方法
 *
 *  @param aPath 音乐的路径 必须传绝对路径
 *  @param aType 音乐的类型
 *
 *  @return 播放成功与否的bool
 */
-(BOOL)playWithPath:(NSString *)aPath andType:(kCZMusicType)aType{
    switch (aType) {
        case kCZMusicTypeLocal:
        {
            
            if (![[aPath lastPathComponent] isEqualToString:[self.player.url lastPathComponent]] )
            
            {
                self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:aPath] error:nil];
            
                [self.player prepareToPlay];
                //开启倍率调节
                //[self.player setEnableRate:YES];
                
               // [self.player setRate:1];
            }
             return  [self.player play];
        }
    
            break;
            
        default:
            
            NSLog(@"ERROR:未完成的部分");
            break;
    }
    return NO;
}


-(BOOL)playWithMusic:(CZMusicModel*)model{
    switch (model.type) {
        case kCZMusicTypeLocal:
        {
            
            if (![[model.mp3 lastPathComponent] isEqualToString:[self.player.url lastPathComponent]] )
                
            {
                self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:model.mp3 withExtension:nil] error:nil];
                
                [self.player prepareToPlay];
                //开启倍率调节
                //[self.player setEnableRate:YES];
                
                // [self.player setRate:1];
                
            }
            return  [self.player play];
        }
            break;
        default:
            NSLog(@"ERROR:未完成的部分");
            break;
    }
    return NO;
}

-(BOOL)pause
{
    if (_player) {
        [_player pause];
        return   YES;
    }
    return NO;
}

@end
