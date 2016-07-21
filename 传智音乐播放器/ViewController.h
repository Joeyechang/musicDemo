//
//  ViewController.h
//  TT音乐播放器
//
//  Created by chang on 16/07/21.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CZLabel.h"
@interface ViewController : UIViewController <UIScrollViewDelegate>

//UI属性
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UILabel *zhuanji;
@property (weak, nonatomic) IBOutlet CZLabel *lyric;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UIScrollView *hScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *vScroll;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

//数据
@property (strong ,nonatomic) NSMutableArray *mList;
@property (strong ,nonatomic) NSMutableArray *lList;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)prev:(id)sender;
- (IBAction)next:(id)sender;

@end

