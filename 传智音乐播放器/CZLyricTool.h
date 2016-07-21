//
//  CZLyricTool.h
//  TT音乐播放器
//
//  Created by chang on 15/1/4.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZLyricTool : NSObject


/**
 *  从一个url中解析出一行行的歌词(CZLyricModel) 添加到数组中
 *
 *  @param aURL 绝对url
 *
 *  @return 包含有该歌词文件所有行数的(CZLyricModel*)数组
 */

+(NSMutableArray *)lyricListFromLrcFile:(NSURL*)aURL;

@end
