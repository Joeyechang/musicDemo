//
//  CZLabel.m
//  TT音乐播放器
//
//  Created by chang on 15/1/6.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "CZLabel.h"

@implementation CZLabel

-(void)setProgress:(CGFloat)progress
{
    _progress=progress;
    
    //当前歌词加粗加大
    if (progress==0) {
        self.font=[UIFont systemFontOfSize:14];
    }else
        self.font=[UIFont boldSystemFontOfSize:16];
    
    [self setNeedsDisplay];
}

-(UIColor *)tintColor
{
    if (!_tintColor) {
        _tintColor=[UIColor greenColor];
    }
    return _tintColor;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    [self.tintColor setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, rect.size.width*_progress, rect.size.height), kCGBlendModeSourceIn);
    
    
}


@end
