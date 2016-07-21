//
//  ViewController.m
//  TT音乐播放器
//
//  Created by chang on 16/07/21.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "ViewController.h"

#define PLAY_TAG 10001
#define PAUSE_TAG 10002

#define LYRIC_ROW_HEIGHT 40


@interface ViewController ()

@end

// 任务1: 主循环 和 更新当前曲目中 做 时间转换mm:ss

long currentMusicIndex=0;
long currentLyricIndex=0;

CZMusicModel *currentMusic;


//开个NSTimer任务
NSTimer *timer;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化UI
    [self initUI];
    
    
    //在viewDidLoad函数中 我们scrollView的frame还是600*600
    
    //想得到适配过后的_hsrcoll.bounds.width做contentsize.width
    
    //适配后的frame信息 在viewDidLayoutSubviews
    
}

-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [_hScroll setContentSize:CGSizeMake(_hScroll.bounds.size.width*2, _hScroll.bounds.size.height)];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self loadData];
    });
    
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 创建毛玻璃效果
 */
-(void)initUI{
    /**
     创建毛玻璃效果
     */
    
    
    //创建一个UIToolbar  frame大小填满bgimage
    UIToolbar *tb= [[UIToolbar alloc]init];
    
    //将barStyle设置为Opaque(全透明)
    
    
    
    [tb setBarStyle:UIBarStyleBlack];// UIBarStyleBlackOpaque
    
    [_bgImage addSubview:tb];
    
    //用代码设置他的frame信息
    
    //1.关掉他的autoResizing
    
    [tb setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    //2.添加约束
    
    //水平方向
    [_bgImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tb]-0-|" options:0 metrics:nil views:@{@"tb":tb}]];
    //垂直方向
    [_bgImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tb]-0-|" options:0 metrics:nil views:@{@"tb":tb}]];
    

}


//重新加载当前的曲目信息
-(void)reloadUI{
    currentMusic=_mList[currentMusicIndex];
    currentLyricIndex=0;
    [_singer setText:currentMusic.singer];
    [_zhuanji setText:currentMusic.zhuanji];
    [_bgImage setImage:[UIImage imageNamed:currentMusic.image]];
    [_albumImage setImage:[UIImage imageNamed:currentMusic.image]];
    
    //设置总时间 0.12345---> mm:ss  1:2  01:02
    
    //直接用字符串 拼接 成float
    
    NSTimeInterval totalTime=[[CZMusicTool sharedInstance]duration];
    
    //对60取商
    int min=totalTime/60;
    int second=(int)totalTime%60;
    
    [_totalTime setText:[NSString stringWithFormat:@"%02d:%02d",min,second]];
    [_currentTime setText:[NSString stringWithFormat:@"%02d:%02d",0,0]];
    _lList= [CZLyricTool lyricListFromLrcFile:[[NSBundle mainBundle]URLForResource:currentMusic.lrc withExtension:nil]];
    
    self.title=currentMusic.name;
    
    //重新调整全景歌词
    
    [self resetLyricScroll];
    
}

//重新调整全景歌词

-(void)resetLyricScroll
{
    //移除所有之前的
    for (UIView *view in _vScroll.subviews) {
        [view removeFromSuperview];
    }
    
    //添加新的
    for (int i=0; i<_lList.count; i++) {
        CZLabel *line=[CZLabel new];
        //[line setFrame:CGRectMake(0, LYRIC_ROW_HEIGHT*i, 320,LYRIC_ROW_HEIGHT)];
        CZLyricModel *m=_lList[i];
        [line setTextColor:[UIColor whiteColor]];
        [line setText:m.text];
        [line setTag:30000+i];
        [line setFont: [UIFont systemFontOfSize:14]];
        [_vScroll addSubview:line];
        [line setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_vScroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[line]" options:0 metrics:nil views:@{@"line":line}] ];
        [_vScroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[line(height)]" options:0 metrics:@{@"top":@(LYRIC_ROW_HEIGHT*i),@"height":@LYRIC_ROW_HEIGHT} views:@{@"line":line}] ];
        [_vScroll addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_vScroll attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    }
    [_vScroll setContentSize:CGSizeMake(_hScroll.bounds.size.width, LYRIC_ROW_HEIGHT*_lList.count)];
    [_vScroll setContentInset:UIEdgeInsetsMake(_vScroll.bounds.size.height/2, 0, _vScroll.bounds.size.height/2, 0)];
    [_vScroll setContentOffset:CGPointMake(0, -_vScroll.contentInset.top)];

}



//加载数据源
-(void)loadData{

    _mList =[NSMutableArray array];
    //读取歌曲列表

    NSArray * arr= [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"mlist.plist" withExtension:nil ]];
    
    
    //把dictionary转成我们的数据模型对象
    for (NSDictionary *dic in arr) {
        [_mList addObject:[CZMusicModel modelWithDictionary:dic]];
    }
    
    [self reloadUI];
    


}


#pragma mark ======scrollViewDelegate==========
#pragma ======scrollViewDelegate=======

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat deltax=scrollView.contentOffset.x;
   
    
    //delta>=320   alpha    ~~~0
    
    //delata=0   alpha      ~~~1
    
    //_groupView.alpha = (scrollView.bounds.size.width-deltax)/scrollView.bounds.size.width;
    
    
    _groupView.alpha=1-deltax/scrollView.bounds.size.width;
    
    if (deltax>=_hScroll.bounds.size.width) {
        [_pager setCurrentPage:1];
    }else
    {
        [_pager setCurrentPage:0];
    }

}


#pragma mark =====主循环==========
#pragma ======每1秒钟来一次=======

-(void)updatePerSecond
{
    
    //两个设置progress方法
   // [_progressView setProgress:[CZMusicTool sharedInstance].progress];
   // NSLog(@"%f",[CZMusicTool sharedInstance].currentTime);
    
    
    /**
     *  更新当前时间label
     */
    NSTimeInterval currentTime=[[CZMusicTool sharedInstance]currentTime];
    
    //对60取商
    int min=currentTime/60;
    int second=(int)currentTime%60;
    
    [_currentTime setText:[NSString stringWithFormat:@"%02d:%02d",min,second]];
    
    
    /**
     *  更新进度条
     */
    [_progressView setProgress:[CZMusicTool sharedInstance].progress animated:YES];
    
    
    /**
     *  更新歌词
     *
     */
    [self updateLyric];
    
}

//更新锁屏图片
-(void)updateLyric
{
    
    
    
    
     NSTimeInterval currentTime=[[CZMusicTool sharedInstance]currentTime];
    NSTimeInterval nextTime=[[CZMusicTool sharedInstance]duration];
    //防止越界
    
    
    if (currentLyricIndex<_lList.count-2){
        CZLyricModel *nextLine=_lList[currentLyricIndex+1];
        //跳行
        if (nextLine .time<=[CZMusicTool sharedInstance].currentTime) {
            currentLyricIndex++;
            [_vScroll setContentOffset:CGPointMake(0, currentLyricIndex*LYRIC_ROW_HEIGHT-_vScroll.contentInset.top) animated:YES];
            
            //进度归零
            for (CZLabel *label in _vScroll.subviews) {
                [label setProgress:0];
            }
        }
        
        
        nextLine=_lList[currentLyricIndex+1];
        nextTime=nextLine.time;
    }
    CZLyricModel *currentLine=_lList[currentLyricIndex];
    [_lyric setText:currentLine.text];
    
    CGFloat progress=(currentTime-currentLine.time)/(nextTime-currentLine.time);
    
    
    CZLabel *textInRows=(CZLabel *)[_vScroll viewWithTag:30000+currentLyricIndex];
    
    [textInRows setProgress:progress];
    
    //合成锁屏图片
    UIImage *image=_albumImage.image;
    
    CGFloat width=self.view.bounds.size.width;
  //  CGFloat height=self.view.bounds.size.height;
    CGRect rect=CGRectMake(0, 0, width, width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    
    
    
    [[UIColor whiteColor]setFill];
    [currentLine.text drawInRect:CGRectMake(0, width-60, width, 60) withFont:[UIFont systemFontOfSize:20] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    [[UIColor greenColor]setFill];
    UIRectFillUsingBlendMode(CGRectMake(0, width-60, width*progress, 60), kCGBlendModeSourceIn);
    
    
    UIImage *currentImage=UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(context, rect);
    
    
    [image drawInRect:rect];
    
    UIImage *mask= [UIImage imageNamed:@"lock_lyric_mask"];
    
    
    [mask drawInRect:CGRectMake(0, 2*width/3, width, width/3) ];

    [currentImage drawInRect:rect];
   
    
    
    UIImage *output=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //更新锁屏信息
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    dic[MPMediaItemPropertyArtist]=currentMusic.singer;
    dic[MPMediaItemPropertyAlbumTitle]=currentMusic.zhuanji;
    dic[MPMediaItemPropertyTitle]=currentMusic.name;
    dic[MPMediaItemPropertyArtwork]=[[MPMediaItemArtwork alloc]initWithImage:output];
    dic[MPMediaItemPropertyPlaybackDuration]=@([CZMusicTool sharedInstance].duration);
    dic[MPNowPlayingInfoPropertyElapsedPlaybackTime]=@([CZMusicTool sharedInstance].currentTime);
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo=dic;
    
}

#pragma mark
#pragma ======播放器的4个控制==========
#pragma ======播放器的4个控制=======

- (IBAction)play:(id)sender {
    
    //UIWebView
    
    currentMusic=_mList[currentMusicIndex];
    
//    [[CZMusicTool sharedInstance] playWithPath:[[NSBundle mainBundle]pathForResource:currentMusic.mp3 ofType:nil]   andType:currentMusic.type];
    [[CZMusicTool sharedInstance]playWithMusic:currentMusic];
    
    //隐藏播放按钮 显示暂停按钮
    
    
    [[self.view viewWithTag:PLAY_TAG] setHidden:YES];
    [[self.view viewWithTag:PAUSE_TAG] setHidden:NO];
    
    //更新当前的曲目数据信息
    
    [self reloadUI];
    
    timer=  [NSTimer scheduledTimerWithTimeInterval:1.0/10 target:self selector:@selector(updatePerSecond) userInfo:nil repeats:YES];
    
    [self becomeFirstResponder];
      NSLog(@"%d",self.isFirstResponder);
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
}

- (IBAction)pause:(id)sender {
    
    [[CZMusicTool sharedInstance]pause];
    
     //隐藏暂停按钮 显示播放按钮
    
    
    [[self.view viewWithTag:PLAY_TAG] setHidden:NO];
    [[self.view viewWithTag:PAUSE_TAG] setHidden:YES];
    
    [timer fire];
    [timer invalidate];
   
    
}

- (IBAction)prev:(id)sender {
    //序号-1
    currentMusicIndex --;
    
    
    //防止越界
    currentMusicIndex =currentMusicIndex<0?_mList.count-1:currentMusicIndex;
    
    //调用播放方法
    [self play:nil];
    
    
}

- (IBAction)next:(id)sender {
    //序号+1
    currentMusicIndex ++;
    
    currentMusicIndex =currentMusicIndex>=_mList.count?0:currentMusicIndex;
    
    //调用播放方法
    [self play:nil];
    
}



#pragma mark ======监听锁屏按钮==========
#pragma ======<#description#>=======




-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self play:nil];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self pause:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next:nil];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self prev:nil];
            break;
        default:
            NSLog(@"还没实现");
            break;
    }
}

@end
