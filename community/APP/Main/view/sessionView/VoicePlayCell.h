//
//  VoicePlayCell.h
//  community
//
//  Created by MAC on 2019/12/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VedioStatus) {
    VedioStatusFailed,        // 播放失败
    VedioStatusBuffering,     // 缓冲中
    VedioStatusPlaying,       // 播放中
    VedioStatusFinished,       //停止播放
    VedioStatusPause       // 暂停播放
};


@interface VoicePlayCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UILabel *currentTimeLab;
@property (nonatomic,strong)UILabel *totalTimeLab;

@property (nonatomic,strong)UISlider *progSlider;

@property (nonatomic,copy) void(^voicePlayBlock)(id data);

@property (nonatomic,copy) void(^sliderBlock)(NSInteger current);
@property (nonatomic,copy) void(^startBlock)(NSInteger current);

@property (nonatomic,assign)NSInteger currentCount;
@property (nonatomic,assign)NSInteger totalCount;
@property (nonatomic,assign)BOOL isPlaying;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

@property (nonatomic,assign)NSString* mp3Add;

-(void)refreshVoice:(SessionModel *)model;
@property (nonatomic,strong)UILabel *timeLabel;
//重写的音频播放
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) id timeObserver;

/*
 * 是否处于seek阶段/seek中间会存在一个不同步问题
 * 所以在seek中间不处理 addPeriodicTimeObserverForInterval
 */
@property (nonatomic, assign) BOOL isSeeking;
//是否拖拽中
@property (nonatomic, assign) BOOL isDragging;
////播放状态
@property (nonatomic, assign) VedioStatus playerStatus;
//总播放时长
@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) NSInteger maximumValue;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat trackValue;


//菊花
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

NS_ASSUME_NONNULL_END
