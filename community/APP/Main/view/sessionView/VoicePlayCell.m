//
//  VoicePlayCell.m
//  community
//
//  Created by MAC on 2019/12/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "VoicePlayCell.h"

@implementation VoicePlayCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"VoicePlayCell";
    VoicePlayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell =[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    //    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImg];
    //////
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
    [self.contentView addSubview:self.headImg];
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(10);
        make.height.width.equalTo(34);
    }];
    
    self.userNameLab = [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
    }];
    self.timeLabel = [UILabel labelWithTitle:@"时间" font:9 textColor:@"999999" textAlignment:NSTextAlignmentLeft];
      [self.contentView addSubview:self.timeLabel];
      [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.contentView.centerX);
          make.top.equalTo(self.headImg.top).offset(-3);
      }];
    UIImage *img = [UIImage imageNamed:@"chatBgImg"];
    // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(25, 15, 8, 8) resizingMode:UIImageResizingModeStretch];
    self.bgImg.image = img;
    
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"play_mp3icon"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"pause_mp3icon"] forState:UIControlStateSelected];

    [self.playBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playBtn];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(15);
        make.top.equalTo(37);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
    
    self.titleLab = [UILabel labelWithTitle:@"声音名.mp3" font:16*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn.top);
        make.left.equalTo(self.playBtn.right).offset(7);
        make.width.lessThanOrEqualTo(180*K_SCALE);
    }];
    
    self.currentTimeLab = [UILabel labelWithTitle:@"00:00" font:11 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.currentTimeLab];
    
    [self.currentTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.left);
        make.bottom.equalTo(self.playBtn.bottom);
        make.width.equalTo(35*K_SCALE);
    }];
    
    self.progSlider = [[UISlider alloc]init];
    [self addSubview:self.progSlider];
    [self.progSlider setThumbImage:[UIImage imageNamed:@"sliderpot"] forState:UIControlStateNormal];
    [self.progSlider setTintColor:[UIColor colorWithHexString:@"42FFA3"]];
    self.progSlider.minimumValue = 0;
    self.progSlider.maximumValue = 1;
    self.progSlider.value = 0;
    [self.progSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLab.right).offset(3);
        make.centerY.equalTo(self.currentTimeLab.centerY);
        make.width.equalTo(90*K_SCALE);
    }];
    [self.progSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.progSlider addTarget:self action:@selector(sliderPressd) forControlEvents:UIControlEventTouchDown];
    [self.progSlider addTarget:self action:@selector(sliderUp) forControlEvents:UIControlEventTouchUpInside];
    [self.progSlider addTarget:self action:@selector(sliderUp) forControlEvents:UIControlEventTouchUpOutside];
    [self.progSlider addTarget:self action:@selector(sliderUp) forControlEvents:UIControlEventTouchCancel];
    
    self.totalTimeLab = [UILabel labelWithTitle:@"00:00" font:11 textColor:@"AEAEAE" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.totalTimeLab];
    
    [self.totalTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progSlider.right).offset(10);
        make.centerY.equalTo(self.currentTimeLab.centerY);
        make.width.equalTo(35*K_SCALE);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(30);
        make.bottom.equalTo(self.contentView.bottom).offset(-3);
        make.width.equalTo(260);
    }];
    
    self.currentCount = 0;

}


-(void)sliderValueChange:(UISlider *)sender{
//    if(self.blockBack){
//       self.blockBack(sender);
//    }
//    NSInteger value = sender.value;
//    self.currentCount = value;
//    self.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",value/60,value%60];
    
    [self sliderScrubbing];
    
}
-(void)sliderPressd{
    NSLog(@"按下");
//    [self.timer setFireDate:[NSDate distantFuture]];
    [self beiginSliderScrubbing];
    
}



-(void)sliderUp{
    NSLog(@"抬起::%ld",self.currentCount);
//    if (self.sliderBlock) {
//        self.sliderBlock(self.currentCount);
//    }
//    [self.timer setFireDate:[NSDate distantPast]];
   
        
   
    
    
    
    [self endSliderScrubbing];
}
-(void)playVoice:(UIButton *)sender{
    NSLog(@"声音播放");
//    sender.selected = !sender.isSelected;
//    self.isPlaying = sender.isSelected;
    
    if (self.voicePlayBlock) {
        self.voicePlayBlock(sender);
    }
    
//    if (self.mp3Add.length > 5) {
//        [self startP];
//    }
//    [self performSelector:@selector(playButtonAction:)];
    
    
}

-(void)startP{
    [CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:1 repeatInterval:1 update:^{
        if (self.isPlaying) {
            self.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",self.currentCount/60,self.currentCount%60];
            self.progSlider.value = self.currentCount;
            if (self.currentCount<self.totalCount) {
                self.currentCount ++;
            }else{
                self.playBtn.selected = NO;
                self.currentTimeLab.text = @"00:00";
            }
            
        }
        
    }];
}





#pragma mark 初始化播放文件，只允许在播放按钮事件使用
- (void)initMusic {
    self.player = [[AVPlayer alloc]init];
    [self initPlayerItem];
    [self addPlayerListener];
}

//修改playerItem
- (void)initPlayerItem {
    if (self.mp3Add && ![self.mp3Add isEqualToString:@""]) {
        
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.mp3Add]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
}

//添加监听文件,所有的监听
- (void)addPlayerListener {
    
    //自定义播放状态监听
    [self addObserver:self forKeyPath:@"playerStatus" options:NSKeyValueObservingOptionNew context:nil];
    if (self.player) {
        //播放速度监听
        [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (self.playerItem) {
        //播放状态监听
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //缓冲进度监听
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //播放中监听，更新播放进度
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float currentPlayTime = (double)weakSelf.playerItem.currentTime.value/weakSelf.playerItem.currentTime.timescale;
            if (weakSelf.playerItem.currentTime.value<0) {
                currentPlayTime = 0.1; //防止出现时间计算越界问题
            }
            
            NSLog(@"当前播放到:%f",currentPlayTime);
            //拖拽期间不更新数据
            if (!weakSelf.isDragging) {
                weakSelf.progSlider.value = currentPlayTime;
                weakSelf.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(currentPlayTime)/60,lround(currentPlayTime)%60];
            }
        }];
        
    }
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //监听应用后台切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //播放中被打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

}



//销毁player,无奈之举 因为avplayeritem的制空后依然缓存的问题。
- (void)destroyPlayer {
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeTimeObserver:self.timeObserver];
    
    self.playerItem = nil;
    self.player = nil;
    
    self.playerStatus = VedioStatusPause;
    self.progSlider.value = 0;
    self.currentTimeLab.text = @"00:00";
}

- (void)changeMusic {
    if (self.mp3Add && ![self.mp3Add isEqualToString:@""]) {
        if (self.playerItem && self.player) {
            [self destroyPlayer];
        
        }
    } else {
        [self pause];
    }
}

- (void)changAndPlayMusic {
    if (self.mp3Add && ![self.mp3Add isEqualToString:@""]) {
        
            [self destroyPlayer];
           
            
            [self initMusic];
            [self play];
    
    } else {
        [self pause];
    }

}


#pragma mark 播放，暂停
- (void)play{
    if (self.player && self.playerStatus == VedioStatusPause) {
        NSLog(@"通过播放停止");
        self.playerStatus = VedioStatusBuffering;
        [self.player play];
    }
}

- (void)pause{
    if (self.player && self.playerStatus != VedioStatusPause) {
        NSLog(@"通过暂停停止");
        self.playerStatus = VedioStatusPause;
        [self.player pause];
    }
}

#pragma mark 监听播放完成事件
-(void)playerFinished:(NSNotification *)notification{
    NSLog(@"播放完成");
    [self.playerItem seekToTime:kCMTimeZero];
    [self pause];
}

#pragma mark 播放失败
-(void)playerFailed{
    NSLog(@"播放失败");
     [[MYToast makeText:@"播放失败"]show];
    [self destroyPlayer];
}

#pragma mark 播放被打断
- (void)handleInterruption:(NSNotification *)notification {
    [self pause];
}

#pragma mark 进入后台，暂停音频
- (void)appEnteredBackground {
    [self pause];
}

#pragma mark 监听捕获
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([self.playerItem status] == AVPlayerStatusReadyToPlay) {
            //获取音频总长度
            CMTime duration = item.duration;
            self.progSlider.maximumValue = CMTimeGetSeconds(duration);
            self.maximumValue = CMTimeGetSeconds(duration);
            self.totalTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(CMTimeGetSeconds(duration))/60,lround(CMTimeGetSeconds(duration))%60];
            NSLog(@"AVPlayerStatusReadyToPlay -- 音频时长%f",CMTimeGetSeconds(duration));
            
        }else if([self.playerItem status] == AVPlayerStatusFailed) {
            
            [self playerFailed];
            NSLog(@"AVPlayerStatusFailed -- 播放异常");
            
        }else if([self.playerItem status] == AVPlayerStatusUnknown) {
            
            [self pause];
            NSLog(@"AVPlayerStatusUnknown -- 未知原因停止");
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        NSArray * array = item.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
//        self.timeSlider.trackValue = totalBuffer;
        //当缓存到位后开启播放，取消loading
        if (totalBuffer >self.progSlider.value && self.playerStatus != VedioStatusPause) {
            [self.player play];
        }
        NSLog(@"---共缓冲---%.2f",totalBuffer);
    } else if ([keyPath isEqualToString:@"rate"]){
        AVPlayer *item = (AVPlayer *)object;
        if (item.rate == 0) {
            if (self.playerStatus != VedioStatusPause) {
                self.playerStatus = VedioStatusBuffering;
            }
        } else {
            self.playerStatus = VedioStatusPlaying;
            
        }
        NSLog(@"---播放速度---%f",item.rate);
    } else if([keyPath isEqualToString:@"playerStatus"]){
        switch (self.playerStatus) {
            case VedioStatusBuffering:
//                [self.timeSlider.sliderBtn showActivity:YES];
                break;
            case VedioStatusPause:
                [self.playBtn setImage:[UIImage imageNamed:@"play_mp3icon"] forState:UIControlStateNormal];
//                [self.timeSlider.sliderBtn showActivity:NO];
                break;
            case VedioStatusPlaying:
                [self.playBtn setImage:[UIImage imageNamed:@"pause_mp3icon"] forState:UIControlStateNormal];
//                [self.timeSlider.sliderBtn showActivity:NO];
                break;

            default:
                break;
        }
    }
}

#pragma mark 监听拖拽事件,拖拽中、拖拽开始、拖拽结束

// 开始拖动
- (void)beiginSliderScrubbing {
    self.isDragging = YES;
}

// 拖动值发生改变
- (void)sliderScrubbing {
    if (self.totalTime != 0) {
        self.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(self.progSlider.value)/60,lround(self.progSlider.value)%60];
    }
}

// 结束拖动
- (void)endSliderScrubbing {
    self.isDragging = NO;
    CMTime time = CMTimeMake(self.progSlider.value, 1);
   
    NSLog(@"当前%f",self.progSlider.value);
    NSLog(@"总%f",self.maximumValue);
     NSLog(@"比%f",self.progSlider.value/self.maximumValue);
    
    
    if (self.playerStatus != VedioStatusPause) {
        [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//        [self.player pause];
//        [self.playerItem seekToTime:time completionHandler:^(BOOL finished) {
//
//            [self.player play];
//            self.playerStatus = VedioStatusBuffering; //结束拖动后处于一个缓冲状态?如果直接拖到结束呢？
//        }];
    }
}

#pragma mark 播放按钮事件
- (void)playButtonAction {
    if (self.player) {
        if (self.playerStatus == VedioStatusPause) {
            [self play];
        } else {
            [self pause];
        }
    } else {
        [self initMusic];
        [self play];
    }
}
- (void)dealloc
{
    [self destroyPlayer];
//    [self removeObserver:self forKeyPath:@"playerStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)refreshVoice:(SessionModel *)model{
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    self.userNameLab.text = model.nick_name;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    self.mp3Add = model.content;
//    self.mp3Add = @"https://www.0dutv.com/upload/dance/20200301/8EFCDEB98EE52CFE767B054BEE668A8D.mp3";
    self.currentCount = 0;
    self.totalCount = model.timeset;
    self.progSlider.maximumValue = model.timeset;
    self.maximumValue = model.timeset;
    self.totalTime = model.timeset;
    self.playBtn.selected = model.mp3isPlaying;
    self.titleLab.text = [model.name stringByAppendingString:@".mp3"];
    self.totalTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",model.timeset/60,model.timeset%60];
    NSLog(@"bofang::%d",model.mp3isPlaying);
    
    
}

@end
