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
        make.top.equalTo(2);
        make.height.width.equalTo(34);
    }];
    
    self.userNameLab = [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
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
        make.top.equalTo(30);
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
    self.progSlider.maximumValue = 1000;
    
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
        make.top.equalTo(23);
        make.bottom.equalTo(self.contentView.bottom).offset(-3);
        make.width.equalTo(260);
    }];
    
    self.currentCount = 0;
    self.progSlider.maximumValue = 100;
    self.progSlider.minimumValue = 0;
}


-(void)sliderValueChange:(UISlider *)sender{
//    if(self.blockBack){
//       self.blockBack(sender);
//    }
    NSInteger value = sender.value;
    self.currentCount = value;
    self.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",value/60,value%60];
}
-(void)sliderPressd{
    NSLog(@"按下");
//    [self.timer setFireDate:[NSDate distantFuture]];
}
-(void)sliderUp{
    NSLog(@"抬起::%ld",self.currentCount);
    if (self.sliderBlock) {
        self.sliderBlock(self.currentCount);
    }
//    [self.timer setFireDate:[NSDate distantPast]];
}
-(void)playVoice:(UIButton *)sender{
    NSLog(@"声音播放");
    sender.selected = !sender.isSelected;
    self.isPlaying = sender.isSelected;
    
    if (self.voicePlayBlock) {
        self.voicePlayBlock(sender);
    }
    
    [CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:1 repeatInterval:1 update:^{
        if (sender.isSelected) {
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

-(void)refreshVoice:(SessionModel *)model{
    self.currentCount = 0;
    self.totalCount = model.timeset;
    self.progSlider.maximumValue = model.timeset;
    self.playBtn.selected = model.mp3isPlaying;
    self.titleLab.text = [model.name stringByAppendingString:@".mp3"];
    self.totalTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",model.timeset/60,model.timeset%60];
    NSLog(@"bofang::%d",model.mp3isPlaying);
}

@end
