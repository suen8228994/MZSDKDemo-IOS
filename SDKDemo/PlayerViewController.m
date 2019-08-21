//
//  PlayerViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/22.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "PlayerViewController.h"
#import <MZMediaSDK/MZMediaPlayerView.h>
#import "AppDelegate.h"
#import "Constant.h"
#define TopMargin 20

#define MinPlayerHeight (kDWidth / 16 * 9)
#if kDHeight
#else

#define kDHeight [UIScreen mainScreen].bounds.size.height

#endif

#if kDWidth
#else

#define kDWidth [UIScreen mainScreen].bounds.size.width

#endif

@interface PlayerViewController ()<MZMediaPlayerViewDelegate,MZMediaPlayerViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)MZMediaPlayerView  *playerView;
@property (nonatomic, strong)UIView             *headerView;
@property (nonatomic, strong)UITextField        *field;
@property (nonatomic, strong)UIButton           *playBtn;
@property (nonatomic,strong)UIView              *btnView;
@property (nonatomic, strong)NSString *mvUrl;
@end

@implementation PlayerViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
}

- (void)setNavigationbar

{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, NavY, screenRect.size.width, NavH)];
    
    //    navigationBar.tintColor = COLOR(200, 100, 162);;
    
    //创建UINavigationItem
    
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"播放"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    
    //设置barbutton
    
    navigationBarTitle.leftBarButtonItem = item;
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    
    
}

-(void)navigationBackButton:(UIBarButtonItem *)item{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.fullScreen = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    _mvUrl = @"rtmp://live.t.zmengzhu.com/mz/99bb07b8f70f349600081772?auth_key=1566301067-0-0-67e1ea9eabf4157f29839497fd5f112d";
    _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, NavY+NavH+TopMargin, kDWidth, kDHeight-650)];
    _headerView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_headerView];
    
    
    _playerView=[[MZMediaPlayerView alloc]init];
    [_playerView playerViewWithUrl:_mvUrl isLive:YES  WithView:_headerView  WithDelegate:self];

    [_playerView startPlayer];
    [_playerView.playerManager setPauseInBackground:NO];
    _btnView=[[UIView alloc]initWithFrame:CGRectMake(0, NavY+NavH+_playerView.frame.size.height+20, _playerView.frame.size.width,200)];
    _field=[[UITextField alloc]init];
    _field.frame=CGRectMake(0, 0, _playerView.frame.size.width, 40);
    _field.borderStyle = UITextBorderStyleRoundedRect;
    _field.delegate = self;
    _field.backgroundColor=[UIColor redColor];
    [_btnView addSubview:_field];
    _playBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, _field.frame.origin.y+_field.frame.size.height+20, 50, 30)];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    _playBtn.backgroundColor=[UIColor blueColor];
    [_playBtn addTarget:self action:@selector(clickPlayer) forControlEvents:UIControlEventTouchDown];
    [_btnView addSubview:_playBtn];
    [self.view addSubview:_btnView];
    UIButton *seekBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, _playBtn.frame.origin.y+_playBtn.frame.size.height+20, 50, 30)];
    [seekBtn addTarget:self action:@selector(clickSeekTO) forControlEvents:UIControlEventTouchDown];
    [seekBtn setTitle:@"快进" forState:UIControlStateNormal];
    seekBtn.backgroundColor=[UIColor blueColor];
    [_btnView addSubview:seekBtn];
    [_playerView showPreviewImage:@"https://inews.gtimg.com/newsapp_ls/0/9563866905_294195/0"];
//    [_playerView.mediaControl.playButton setImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
//    [playerView setHistoryPlayingTime:@"1000"];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

-(void)clickSeekTO{
//    [_playerView.playerManager stop];
//    [self.playerView seekTo:10];
//    self.playerView.playerManager.currentPlaybackTime=10;
//    [_playerView.playerManager shutdown];
}

-(void)clickPlayer{
//    _playerView.playerManager=nil;
//    [_playerView  playerWillShow];
    [_playerView startPlayer];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeRight){
        UIWindow*window= [UIApplication sharedApplication].keyWindow;
        _playerView.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.preview.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.mediaControl.fullScreenBtn.selected=YES;
        _playerView.isFullScreen=YES;
        [window addSubview:_playerView];
    }else{
        _playerView.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _playerView.preview.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _playerView.mediaControl.fullScreenBtn.selected=NO;
        _playerView.isFullScreen=NO;
        [_headerView addSubview:_playerView];
        _field.frame=CGRectMake(0, _playerView.frame.size.height+20, _playerView.frame.size.width, 40);
        [_headerView addSubview:_field];
        
        
        
    }
}

- (void)playerViewClosed:(MZMediaPlayerView *)player{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    
}

- (void)playerView:(MZMediaPlayerView *)player fullscreen:(BOOL)fullscreen{
    
    
    
    if (fullscreen==YES) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
    }else{
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//播放失败
- (void)playerViewFailePlay:(MZMediaPlayerView *)player{
    
}

/**
 快进退 进度回调
 */
- (void)playerSeekProgress:(NSTimeInterval)progress{
    NSLog(@"playerSeekProgress---%f",progress);
}
/**
 快进退 手势回调
 */
-(void)playerSeekLocation:(float)location{
    NSLog(@"playerSeekLocation---%f",location);
}

/**
 声音大小手势回调
 */
-(void)playerVoiceSize:(float)size{
    NSLog(@"playerVoiceSize---%f",size);
}
/**
 亮度手势回调
 */
-(void)playerLuminance:(float)luminance{
    NSLog(@"playerLuminance---%f",luminance);
}
//是否显示下方工具栏
- (void)isPlayToolsShow:(BOOL)isShow{
    NSLog(@"isPlayToolsShow---%f",isShow?0.1:0.2);
}

@end

