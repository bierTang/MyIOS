//
//  SessionVideoCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/10.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "SessionVideoCell.h"

@implementation SessionVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"SessionVideoCell";
    //复用
    SessionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
     //精准取出一行  禁止复用
//    SessionVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];//运用这个就可以禁止复用了

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
    
    self.videoImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.videoImg];
    
    self.videoImg.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImg.clipsToBounds = YES;
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33);
        make.left.equalTo(self.headImg.right).offset(12);
        make.width.equalTo(260*K_SCALE);
//        make.height.greaterThanOrEqualTo(160*K_SCALE);
//        make.height.lessThanOrEqualTo(310*K_SCALE);
        make.height.equalTo(300*K_SCALE);

    }];
    UIView *grayView = [UIView new];
    [self.videoImg addSubview:grayView];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.top.equalTo(0);
    }];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.3;
    
    self.videoImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
    [self.videoImg addGestureRecognizer:tap];
    
    
    UIImageView *playImg = [[UIImageView alloc]init];
    [self.contentView addSubview:playImg];
    playImg.image = [UIImage imageNamed:@"playBtn_icon"];
    [playImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoImg.centerX);
        make.centerY.equalTo(self.videoImg.centerY);
    }];
    
    self.describLab = [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.describLab.numberOfLines = 0;
    [self.contentView addSubview:self.describLab];
    
    [self.describLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoImg.left);
        make.top.equalTo(self.videoImg.bottom).offset(5);
        make.width.equalTo(self.videoImg.width);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(30);
        make.bottom.equalTo(self.describLab.bottom).offset(3);
        make.right.equalTo(self.videoImg.right).offset(3);
    }];
}
-(void)playVideo{
    if(self.backBlock){
        NSLog(@"设置的tag是%ld",(long)self.videoImg.tag);
        self.backBlock([NSString stringWithFormat:@"%ld",(long)self.videoImg.tag]);
    }
}



-(void)refreshCell:(SessionModel *)model index:(NSInteger *)i{
//    NSLog(@"加载了：：%d",model.hadLoaded);
    
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    self.userNameLab.text = model.nick_name;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"1"]];
    __weak typeof(self) wself = self;
    
//   self.videoImg.tag = i;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.images]] placeholderImage:[UIImage imageNamed:@"loadNormal"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"图片错误：：%@--%ld",error,cacheType);
        if (image.size.height > image.size.width) {
            [self.videoImg updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(205*K_SCALE);
            }];
        }else{
            [self.videoImg updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(260*K_SCALE);
            }];
        }
        if (!error && wself.backBlock && cacheType != SDImageCacheTypeMemory) {
            wself.backBlock(@"99999");
        }
        
        
    }];
    
    if (model.descriptions.length > 0) {
        self.describLab.text = model.descriptions;
    }else{
        self.describLab.text = @"";
    }
    
}



@end
