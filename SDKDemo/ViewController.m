//
//  ViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/17.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "ViewController.h"
#import "TestLiveStream.h"
#import "PushViewController.h"
#import "PlayerViewController.h"
#import <MZMediaSDK/MZPlayerManager.h>
#import <MZMediaSDK/MZSDKInitManager.H>
#import "Constant.h"
@interface ViewController (){
    UIButton *pushBtn;
    UIButton *playerBtn;
    UIButton *playerViewBtn;
    MZPlayerManager *manager;
}
@property (nonatomic, strong) TestLiveStream *testVideoCapture;
@end

@implementation ViewController
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
    
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"SDKdemo"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MZSDKInitManager* manager=[MZSDKInitManager sharedManager];
    [manager initSDK:MZ_ONLINE_TYPE token:@"f117526418fd24b3294aca1ed0c2b896_156136291484092_1566301110" success:^(id responseObject) {
      
        NSLog(@"%d",manager.isPassValidation);
    } failure:^(NSError *error) {
        NSLog(@"%@",manager.errorMsg);
    }];
    pushBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, NavY+NavH, self.view.bounds.size.width, 40)];
    [pushBtn setTitle:@"推流" forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(onPushClick) forControlEvents:UIControlEventTouchDown];
    [pushBtn setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:pushBtn];
    playerBtn=[[UIButton alloc]initWithFrame:CGRectMake(pushBtn.frame.origin.x, pushBtn.frame.origin.y+pushBtn.frame.size.height+30, self.view.bounds.size.width, 40)];
    [playerBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playerBtn setBackgroundColor:[UIColor blueColor]];
    [playerBtn addTarget:self action:@selector(onPlayerClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerBtn];
    
    playerViewBtn=[[UIButton alloc]initWithFrame:CGRectMake(playerBtn.frame.origin.x, playerBtn.frame.origin.y+playerBtn.frame.size.height+30, self.view.bounds.size.width, 40)];
    [playerViewBtn setTitle:@"基础播放器" forState:UIControlStateNormal];
    [playerViewBtn setBackgroundColor:[UIColor blueColor]];
    [playerViewBtn addTarget:self action:@selector(onPlayerViewClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playerViewBtn];
    
    
    
//    [manager play];
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.testVideoCapture onLayout];
}

-(void)onPlayerClick{
    [self presentViewController:[[PlayerViewController alloc]init] animated:YES completion:nil];
    

}
-(void)onPlayerViewClick{
        CGFloat autoPlayer_H = (self.view.bounds.size.width / 16 * 9);
        CGFloat top = (self.view.bounds.size.height - autoPlayer_H)/2;
        CGRect playFrame = CGRectMake(0, top, self.view.bounds.size.width, autoPlayer_H);
        manager=[[MZPlayerManager alloc]initWithContentURLString:@"http://vod.dev.zmengzhu.com/record/base/hls-sd/042dca9d63ae07d300006491.m3u8" frame:playFrame];
        manager.view.frame=playFrame;
        [self.view addSubview:manager.view];
        manager.shouldShowHudView = NO;
        [manager prepareToPlay];
}


-(void)onPushClick{
//    [self.navigationController pushViewController:[[PushViewController alloc]init] animated:YES];
    [self presentViewController:[[PushViewController alloc]init] animated:YES completion:nil];
}

@end
