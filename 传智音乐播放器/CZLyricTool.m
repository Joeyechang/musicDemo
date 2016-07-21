//
//  CZLyricTool.m
//  TT音乐播放器
//
//  Created by chang on 15/1/4.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "CZLyricTool.h"

@implementation CZLyricTool


/**
 *  从一个url中解析出一行行的歌词(CZLyricModel) 添加到数组中
 *
 *  @param aURL 绝对url
 *
 *  @return 包含有该歌词文件所有行数的(CZLyricModel*)数组
 */

+(NSMutableArray *)lyricListFromLrcFile:(NSURL*)aURL{
    
    //1.文件到字符串
    NSString *orginStr=[NSString stringWithContentsOfURL:aURL encoding:NSUTF8StringEncoding error:nil];

    //2.拆分成一行一行 用换行符 \n来拆分
    NSArray *lines= [orginStr componentsSeparatedByString:@"\n"];
    
    //3.对每一行 ，转换成我们CZLyricModel想要的数据格式?
    //只对格式正确的行 取时间和后面的文字？
    
    //直接用下标取 子字符串是不可取的 正确的做法，我们用[mm:ss.SS]正则表达式 匹配，匹配出来的次数可能是？0,1,2,3,4?
    
    //  \\[(\\d{2}:\\d{2}\\.\\d{2})\\]
    
    
    //[02:38.00]
    
    //把上面的写成正则表达式:
    
    // \[( \d{2} : \d{2}  \. \d{2} )\]
    
    //---》\\[\\d{2}:\\d{2}\\.\\d{2}\\]
    
    
    
    NSRegularExpression *exp=[NSRegularExpression regularExpressionWithPattern:@"\\[(\\d{2}:\\d{2}\\.\\d{2})\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //创建一个formatter 双向的 date-->str   str-->date
    
    
    // \\.
    
    // []
    // \[\]
    // 数字
    // \d{2}
    // :    \.
    
    // \[\d{2}:\d{2}\.\d{2}\]
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"[mm:ss.SS]"];
 
    
    //创建一个空的歌词Array;
    
    NSMutableArray *lyricList=[NSMutableArray array];
    
    
    NSDate *referDate=[formatter dateFromString:@"[00:00.00]"];
    for (NSString *line in lines) {
        
        //每一行
        
        NSArray *results= [exp matchesInString:line options:0 range:NSMakeRange(0, line.length)];
        
        if (results.count!=0) {
            
            for (NSTextCheckingResult *result in results) {
                //拿到每一个匹配到的正则表达式结果的range来对line进行字符串拆分
                NSString *timeStr=[line substringWithRange:result.range];
                
                //取歌词文字？  对results数组的lastobject 的起始位置+长度 =歌词的初始位置
                NSTextCheckingResult *r=results.lastObject;
                //得到第一个字的位置
                NSUInteger index=r.range.location+r.range.length;
                
                NSString *text=[line substringFromIndex:index];
                
                //1999-12-31 16:02:19
                //1999-12-31 16:00:00
                NSDate *date=[formatter dateFromString:timeStr];
                
              //  NSLog(@"%f==>%@",[date timeIntervalSinceDate:referDate],text);
                
                //对[mm:ss.SS]转换成浮点数的方式？
                //1.(取 1~2 转 int *60)+(ss转int)+(SS*0.01)=timerInterval
                
                //2.用NSDateFormatter
                
                //放到我的歌词model中
                
                CZLyricModel *m=[CZLyricModel new];
                [m setTime:[date timeIntervalSinceDate:referDate]];
                [m setText:text];
                
                [lyricList addObject:m];
            }
            
            
            
        }
        
    
    }
    
    
    //对这个数组按time 进行升序排列
    
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    
    [lyricList sortUsingDescriptors:@[sort]];
    
    

    return lyricList;

}

@end
