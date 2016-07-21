//
//  CZMusicModel.h
//  TT音乐播放器
//
//  Created by chang on 15/1/2.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kCZMusicTypeSound = 1 << 0,  //音效
    kCZMusicTypeLocal = 1 << 1,  //本地
    kCZMusicTypeOnline = 1 << 2  //在线
} kCZMusicType;
@interface CZMusicModel : NSObject


@property (strong,nonatomic) NSString * image ;
@property (strong,nonatomic) NSString * lrc ;
@property (strong,nonatomic) NSString * mp3 ;
@property (strong,nonatomic) NSString * name ;
@property (strong,nonatomic) NSString * singer ;
@property (strong,nonatomic) NSString * zhuanji ;
@property (assign,nonatomic) kCZMusicType type;

//通过一个字典创建model
+(instancetype)modelWithDictionary:(NSDictionary*)aDic;
@end
