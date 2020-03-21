//
//  LivePlayVC.m
//  community
//
//  Created by MAC on 2020/2/18.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LivePlayVC.h"

#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "AdsModel.h"

@interface LivePlayVC ()
@property (nonatomic,strong)KSYMoviePlayerController *player;

@property (nonatomic,strong)UIView *videoView;
@property (nonatomic,strong)UIView *noLiveView;
@property (nonatomic,strong)UILabel *titLab;

@property (nonatomic,strong)UIImageView *adImage1;
@property (nonatomic,strong)UIImageView *adImage2;
@property (nonatomic,strong)UIImageView *adImage21;

@property (nonatomic,strong)NSArray<AdsModel *> *adsArr;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)UIScrollView *scrollview;
//菊花
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

@implementation LivePlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.timeSec = 0;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.videoView = [[UIView alloc]init];
    [self.view addSubview:self.videoView];
    [self.videoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TopLiuHai);
        make.bottom.equalTo(BottomSpaceHight);
        make.left.right.equalTo(0);
    }];
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollview];
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT);
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    

    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestADSforType:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"直播广告：：%@",result[@"code"]);
        if (state == AppRequestState_Success) {
            
            
            wself.adsArr = [AdsModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (wself.adsArr.count > 1) {
                wself.adImage1 = [[UIImageView alloc]init];
                wself.adImage1.tag = 0;
                wself.adImage1.alpha = 0.7;
                [wself.scrollview addSubview:wself.adImage1];
                [wself.adImage1 makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(TopLiuHai+30);
                    make.left.equalTo(SCREEN_WIDTH + 100*K_SCALE+20);
                    make.height.equalTo(36*K_SCALE);
                    make.width.equalTo(180*K_SCALE);
                }];
                UITapGestureRecognizer *tap1= [[UITapGestureRecognizer alloc]initWithTarget:wself action:@selector(handtap:)];
                [wself.adImage1 addGestureRecognizer:tap1];
                [wself.adImage1 sd_setImageWithURL:[NSURL URLWithString:wself.adsArr[0].logo] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    wself.adImage1.userInteractionEnabled = YES;
                }];
                
                wself.adImage2 = [[UIImageView alloc]init];
                wself.adImage2.tag = 1;
                wself.adImage2.alpha = 0.7;
                [wself.scrollview addSubview:wself.adImage2];
                [wself.adImage2 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(SCREEN_WIDTH - 80*K_SCALE - 16);
                    make.height.equalTo(33*K_SCALE);
                    make.width.equalTo(80*K_SCALE);
                    make.top.equalTo(SCREEN_HEIGHT-BottomSpace-55*K_SCALE);
                }];
                UITapGestureRecognizer *tap2= [[UITapGestureRecognizer alloc]initWithTarget:wself action:@selector(handtap:)];
                [wself.adImage2 addGestureRecognizer:tap2];
                [wself.adImage2 sd_setImageWithURL:[NSURL URLWithString:wself.adsArr[1].logo] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    wself.adImage2.userInteractionEnabled = YES;
                }];
                
                
                wself.adImage21 = [[UIImageView alloc]init];
                wself.adImage21.tag = 1;
                wself.adImage21.alpha = 0.7;
                [wself.scrollview addSubview:wself.adImage21];
                [wself.adImage21 makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(SCREEN_WIDTH*2 - 80*K_SCALE - 16);
                    make.height.equalTo(33*K_SCALE);
                    make.width.equalTo(80*K_SCALE);
                    make.top.equalTo(SCREEN_HEIGHT-BottomSpace-55*K_SCALE);
                }];
                [wself.adImage21 addGestureRecognizer:tap2];
                [wself.adImage21 sd_setImageWithURL:[NSURL URLWithString:wself.adsArr[1].logo] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    wself.adImage21.userInteractionEnabled = YES;
                }];
                
            }
        }else{
            NSLog(@"错误:");
        }
    }];
    
//    http://199.180.102.241:2100/20200121/Ztwtzq1p/mp4/Ztwtzq1p.mp4
//    http://199.180.102.241:2100/20200214/voHKvcnZ/mp4/voHKvcnZ.mp4
    _player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.model.pull]];
    _player.controlStyle = MPMovieControlStyleNone;
//    [_player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.videoView addSubview:_player.view];
    [_player.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.right.equalTo(0);
    }];
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.shouldAutoplay = YES;
    _player.scalingMode = MPMovieScalingModeAspectFill;

    [_player prepareToPlay];
    
//    [_player play];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeLive"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:closeBtn];
    
    UIButton *closeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn2 setImage:[UIImage imageNamed:@"closeLive"] forState:UIControlStateNormal];
    [closeBtn2 addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:closeBtn2];
    
    ///直播未开始
    self.noLiveView = [[UIView alloc]init];
    [self.view addSubview:self.noLiveView];
    self.noLiveView.backgroundColor = [UIColor whiteColor];
//    noLivetip@2x
    self.noLiveView.layer.cornerRadius = 5;
    [self.noLiveView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(250*K_SCALE);
        make.height.equalTo(260*K_SCALE);
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
    }];
//    self.noLiveView.hidden = YES;
    UIImageView *iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noLivetip"]];
    [self.noLiveView addSubview:iconImg];
    [iconImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.centerX.equalTo(self.noLiveView.centerX);
    }];
    
    UIButton *closeNoLive = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeNoLive setBackgroundImage:[UIImage imageNamed:@"pot_close"] forState:UIControlStateNormal];
    [closeNoLive addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
    [self.noLiveView addSubview:closeNoLive];
    
    [closeNoLive makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(10);
    }];
    
    self.titLab = [UILabel labelWithTitle:@"直播间未开播，或播放地址错误" font:16*K_SCALE textColor:@"000000" textAlignment:NSTextAlignmentCenter];
    [self.noLiveView addSubview:self.titLab];
    [self.titLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(iconImg.bottom).offset(30);
    }];
    self.noLiveView.hidden = YES;
    UILabel *label2 = [UILabel labelWithTitle:@"切换别的房间看看吧" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentCenter];
    [self.noLiveView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.titLab.bottom).offset(8);
    }];
    UIButton *backListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backListBtn setBackgroundImage:[UIImage createImageWithColor:RGBColor(78, 191, 89)] forState:UIControlStateNormal];
    [backListBtn setTitle:@"返回列表" forState:UIControlStateNormal];
    [backListBtn setTintColor:[UIColor whiteColor]];
    backListBtn.titleLabel.font = [UIFont systemFontOfSize:17*K_SCALE];
    [self.noLiveView addSubview:backListBtn];
    backListBtn.layer.cornerRadius = 18*K_SCALE;
    backListBtn.clipsToBounds = YES;
    [backListBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.bottom).offset(30);
        make.height.equalTo(36*K_SCALE);
        make.width.equalTo(190*K_SCALE);
        make.centerX.equalTo(self.noLiveView.centerX);
    }];
    [backListBtn addTarget:self action:@selector(closeLiveView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *grayBgView = [[UIView alloc]init];
    grayBgView.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.5];
    [self.scrollview addSubview:grayBgView];
    grayBgView.layer.cornerRadius = 18*K_SCALE;
    
//    [self.scrollview addSubview:grayBgView];
    [grayBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SCREEN_WIDTH + 10);
        make.height.equalTo(36*K_SCALE);
        make.top.equalTo(TopLiuHai+30);
        make.width.equalTo(100*K_SCALE);
    }];
    UIImageView *headImg = [[UIImageView alloc]init];
    NSString *string = self.model.imgUrl;
    if (self.model.stream.length < 5) {
        string = self.model.stream;
    }
    [headImg sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
    [grayBgView addSubview:headImg];
    headImg.layer.cornerRadius = 18*K_SCALE;
    headImg.clipsToBounds = YES;
    [headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.top.equalTo(0);
        make.width.height.equalTo(36*K_SCALE);
    }];
    UILabel *nameLab = [UILabel labelWithTitle:self.model.userName font:15*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    nameLab.numberOfLines = 1;
    [grayBgView addSubview:nameLab];
    [nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.right).offset(3);
        make.bottom.top.equalTo(0);
        make.right.equalTo(-5);
    }];
    
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(2*SCREEN_WIDTH);
        make.centerY.equalTo(grayBgView.centerY);
       make.width.equalTo(70);
    }];
    
    [closeBtn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SCREEN_WIDTH);
        make.centerY.equalTo(grayBgView.centerY);
        make.height.equalTo(50);
        make.width.equalTo(70);
    }];
//    //放到scrollview上就是在最上面显示
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.scrollview animated:YES];
//    [hud hideAnimated:true afterDelay:2.5];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(100);
       }];
    //设置小菊花的frame
//    self.activityIndicator.frame= CGRectMake(100, 100, 100, 100);
    //设置小菊花颜色
//    self.activityIndicator.color = [UIColor redColor];
//    //设置背景颜色
//    self.activityIndicator.backgroundColor = [UIColor cyanColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
//    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
   
    
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noPlayer:) name:(MPMoviePlayerPlaybackDidFinishNotification)
       object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(starPlayer:) name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
          object:nil];
    
    
    self.timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(handleTimer) userInfo:nil repeats:NO];

}
-(void)handleTimer{
    [self.activityIndicator stopAnimating];
//    [MBProgressHUD hideHUDForView:self.scrollview animated:YES];
//    if (self.player.playbackState == 0){
        self.noLiveView.hidden = NO;
//    }
    
}
-(void)handtap:(UITapGestureRecognizer *)tap{
    NSLog(@"tap::%@",self.adsArr[tap.view.tag].link);
    
    if (self.adsArr[tap.view.tag].link.length > 5) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.adsArr[tap.view.tag].link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.adsArr[tap.view.tag].link]];
        }
    }
    
}

-(void)noPlayer:(NSNotificationCenter *)not{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
//         [MBProgressHUD hideHUDForView:self.scrollview animated:YES];
                           self.noLiveView.hidden = NO;
                       });
}
-(void)starPlayer:(NSNotificationCenter *)not{
    [self.activityIndicator stopAnimating];
//         [MBProgressHUD hideHUDForView:self.scrollview animated:YES];
 
}


-(void)handlePlayerNotify:(NSNotificationCenter *)not{
    NSLog(@"播放状态：：%d--%@",self.player.playbackState,not);
    
//    if ((self.player.playbackState == MPMoviePlaybackStateStopped || self.player.playbackState == MPMoviePlaybackStateInterrupted) && self.timer==nil) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.noLiveView.hidden = NO;
//        });
//
//    }else {
//        [self.timer invalidate];
//        self.timer = nil;
//
//    }
    
    //状态未知
    if(self.player.playbackState == 0){
       NSLog(@"状态未知");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //状态未知
            if (self.player.playbackState == 0){
                NSLog(@"状态未知显示退出");
               dispatch_async(dispatch_get_main_queue(), ^{
                          self.noLiveView.hidden = NO;
                      });
            }
            
        });
    }else {
        NSLog(@"定时器销毁");
        [self.timer invalidate];
        self.timer = nil;

    }
    
    if(self.player.playbackState == MPMoviePlaybackStatePlaying){
        NSLog(@"正在播放");
        [self.activityIndicator stopAnimating];
//        [MBProgressHUD hideHUDForView:self.scrollview animated:YES];
    }
    
//    MPMoviePlaybackStateStopped,
//    MPMoviePlaybackStatePlaying,
//    MPMoviePlaybackStatePaused,
//    MPMoviePlaybackStateInterrupted,
//    MPMoviePlaybackStateSeekingForward,
//    MPMoviePlaybackStateSeekingBackward
}

-(void)closeLiveView{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification) object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:(MPMoviePlayerNetworkStatusChangeNotification) object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:(MPMoviePlayerPlaybackStateDidChangeNotification) object:nil];

    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.noLiveView removeFromSuperview];
    [self.player stop];
    self.player = nil;
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
