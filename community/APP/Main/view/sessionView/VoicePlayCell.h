//
//  VoicePlayCell.h
//  community
//
//  Created by MAC on 2019/12/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic,assign)NSInteger currentCount;
@property (nonatomic,assign)NSInteger totalCount;
@property (nonatomic,assign)BOOL isPlaying;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;


-(void)refreshVoice:(SessionModel *)model;

@end

NS_ASSUME_NONNULL_END
