//
//  CSVideoPlayVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/11.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSVideoPlayVC.h"
#import "CSAlertView.h"
#import "DownVideoTool.h"

@interface CSVideoPlayVC ()
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) UILabel *progLab;
@property (nonatomic,strong)CSTimerManager *timerManager;
@end

@implementation CSVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
        commonSettings.progress_thumbSize = 12;
    });
//    self.playUrl = @"http://beian-cdn.000h5.net/20191224/jZ4w1our/index.m3u8";
//    self.playUrl = @"https://b.mss.ac.cn/live/3685423_1581887955.flv?txSecret=f5b6b5d1dc823f290f84d59ebb2fbbe0&txTime=5E4A1E7B&";
    _player = SJVideoPlayer.player;
    [self.view addSubview:_player.view];
//    [_player playWithURL:[NSURL URLWithString:self.playUrl]];
    _player.supportedOrientation = SJAutoRotateSupportedOrientation_All;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        [KTVHTTPCache logSetConsoleLogEnable:NO];
        [KTVHTTPCache proxyStart:&error];
    });
    
    NSURL *url = [NSURL URLWithString:self.playUrl];
    NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:url];
//    _player = SJVideoPlayer.player;
    if ([self.playUrl hasSuffix:@"m3u8"]) {
        _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:url];
    }else{
        _player.URLAsset = [SJVideoPlayerURLAsset.alloc initWithURL:proxyURL];
    }
    
    if (![HelpTools isMemberShip]) {
                      self.timerManager=[CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:1 repeatInterval:1 update:^{
                          if (self.player.currentTime > 100) {
                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [self.player stopAndFadeOut];
                                  [self.player rotate:SJOrientation_Portrait animated:YES];
                                  [self.player stop];
//                                  self.player = nil;
//                                  cell.noVipView.hidden = NO;
//                                  if ([UserTools isAgentVersion]) {
//                                      cell.noVipView.view2.hidden = YES;
//                                  }
                                 [[MYToast makeText:@"试看结束，请先开通会员"]show];
                              });
                          }
                      }];
                  }
    
    
    
    
//    _player.URLAsset.title = @"视频标题";
//    KTVHTTPCache
//    KTVHTTPCache cacheReaderWithRequest:[KTVHCDataRequest ini]
    
    _player.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_player.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_player.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [_player.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_player.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
//    [_player showTitle:@"视频标题"];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [_player.view addGestureRecognizer:longpress];
    


    
    self.progLab = [UILabel labelWithTitle:@"" font:12 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.progLab];
    
    [self.progLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
    }];
    
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{if(recognizer.direction ==UISwipeGestureRecognizerDirectionDown) {
    NSLog(@"swipe down");
    
}if(recognizer.direction ==UISwipeGestureRecognizerDirectionUp) {
    NSLog(@"swipe up");
    
}if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
    
}if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"swipe right");
    
}}


-(void)longPressAction:(UILongPressGestureRecognizer *)longpress{
    NSLog(@"long::%ld",longpress.state);
    if (self.player.playStatus == SJVideoPlayerPlayStatusInactivity||self.player.playStatus == SJVideoPlayerPlayStatusUnknown) {
        return;
    }
    if (longpress.state == UIGestureRecognizerStateBegan) {
//        CSAlertView *alertView = [[CSAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        alertView.backBlock = ^{
////            [self saveImage];
//            DownVideoTool *dlowd = [DownVideoTool new];
//            [dlowd downloadVideo:self.playUrl];
//            dlowd.progressBlock = ^(id  _Nonnull progress) {
//                NSProgress *progre = progress;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.progLab.text = [NSString stringWithFormat:@"%.2f %%",progre.fractionCompleted * 100];
//                });
//            };
//            dlowd.completBlock = ^{
//                self.progLab.text = @"";
//            };
//        };
//        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }
}

-(void)dealloc{
    NSLog(@"视频播放界面dealloc");
}

@end
