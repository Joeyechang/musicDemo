//
//  CZMusicModel.m
//  TT音乐播放器
//
//  Created by chang on 15/1/2.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "CZMusicModel.h"

@implementation CZMusicModel



+(instancetype)modelWithDictionary:(NSDictionary*)aDic
{

    CZMusicModel *model=[CZMusicModel new];
    [model setValuesForKeysWithDictionary:aDic];
    return  model;

}

@end
