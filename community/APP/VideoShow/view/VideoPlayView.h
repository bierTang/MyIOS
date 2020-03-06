//
//  VideoPlayView.h
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayView : UIView

@property (nonatomic,strong)UIView *videoView;
@property (nonatomic,strong)UIImageView *adsUpImg;
@property (nonatomic,strong)UIImageView *adsDownImg;

@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)CSTimerManager *timerManager;

@property (nonatomic, strong) SJVideoPlayer *player;

-(void)playVideo:(NSString *)videoUrl;


-(void)closeView:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
