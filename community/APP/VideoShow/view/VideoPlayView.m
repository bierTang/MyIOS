//
//  VideoPlayView.m
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "VideoPlayView.h"

@implementation VideoPlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.26];
    
    self.videoView = [[UIView alloc]init];
    [self addSubview:self.videoView];
    
    [self.videoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.right.equalTo(0);
        make.height.mas_greaterThanOrEqualTo(206*K_SCALE);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"pot_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:self.closeBtn];
    [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(10);
    }];
    
    self.adsUpImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"madeOfVideo"]];
    [self addSubview:self.adsUpImg];
    [self.adsUpImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(self.videoView.top);
        make.height.equalTo(125*K_SCALE);
    }];
    
    self.adsDownImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"madeOfVideo"]];
    [self addSubview:self.adsDownImg];
    [self.adsDownImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.videoView.bottom);
        make.height.equalTo(125*K_SCALE);
    }];
    

}
-(void)playVideo:(NSString *)videoUrl{
    
    self.player = [SJVideoPlayer player];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrl]];
  
    __weak typeof(self) wself = self;
    self.player.clickedBackEvent = ^(SJVideoPlayer * _Nonnull player) {
        [wself closeView:nil];
    };
    
    [self.videoView addSubview:self.player.view];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.videoView bringSubviewToFront:self.closeBtn];
//    [self.player.view addSubview:self.closeBtn];
    [self.closeBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(10);
    }];
    
    self.player.fitOnScreen = NO;
    
    if (![HelpTools isMemberShip]) {
        self.timerManager=[CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:1 repeatInterval:1 update:^{
            if (self.player.currentTime > 100) {
                [self closeView:nil];
                [[MYToast makeText:@"试看结束，请先开通会员"]show];
            }
        }];
    }
    
}
-(void)closeView:(UIButton *)sender{
    [self.timerManager pq_close];
    self.hidden = YES;
    [self.player stop];
    self.player = nil;
}

@end
