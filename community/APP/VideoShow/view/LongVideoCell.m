//
//  LongVideoCell.m
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LongVideoCell.h"


@implementation LongVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"LongVideoCell";
//    self.tableview = tableView;
    LongVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.titleLab = [UILabel labelWithTitle:@"标题" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(0);
        make.height.equalTo(35*K_SCALE);
    }];
    
    self.BlurImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
    [self.contentView addSubview:self.BlurImg];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectV = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectV.alpha = 0.9;
    [self.BlurImg addSubview:effectV];
    [effectV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
    self.videoBgView = [[UIView alloc]init];
    self.videoBgView.clipsToBounds = YES;
    self.videoBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.videoBgView];
    [self.videoBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(self.titleLab.bottom);
        make.height.equalTo(210*K_SCALE);
    }];
    
    [self.BlurImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.titleLab.bottom);
        make.bottom.equalTo(self.videoBgView.bottom);
    }];
    
    self.videoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
    [self.videoBgView addSubview:self.videoImg];
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    self.videoImg.userInteractionEnabled = YES;
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"playBtn_icon"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoImg addSubview:playBtn];
    [playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBgView.centerX);
        make.centerY.equalTo(self.videoBgView.centerY);
    }];
    playBtn.tag = 1;
    
    self.showImgBtn = [UIButton buttonWithTitle:@"精彩缩略图" font:14 titleColor:@"999999"];
    [self.contentView addSubview:self.showImgBtn];
    self.showImgBtn.tag = 2;
    [self.showImgBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showImgBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoBgView.bottom);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.equalTo(44*K_SCALE);
    }];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:clickBtn];
    clickBtn.tag =2;
    [clickBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoBgView.bottom);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.equalTo(300);
        make.height.equalTo(44*K_SCALE);
    }];
    
    UIImageView *downIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fold_down"]];
    [self.contentView addSubview:downIcon];
    [downIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showImgBtn.right).offset(9);
        make.centerY.equalTo(self.showImgBtn.centerY);
    }];
    
    UIView *grayView = [[UIView alloc]init];
    [self.contentView addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.top.equalTo(self.showImgBtn.bottom);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    self.noVipView = [[ NoVipView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210*K_SCALE)];
    [self.contentView addSubview:self.noVipView];
    self.noVipView.hidden = YES;
    [self.noVipView makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(0);
           make.right.equalTo(0);
        make.top.bottom.equalTo(self.videoBgView);
//           make.top.equalTo(self.titleLab.bottom);
//           make.height.equalTo(210*K_SCALE);
       }];
    self.noVipView.bt1.tag = 3;
    [self.noVipView.bt1 addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.noVipView.bt2.tag = 4;
    [self.noVipView.bt2 addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)refreshData:(VideoModel *)model{
    self.noVipView.hidden = YES;
    [self.BlurImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    self.noVipView.hidden = YES;
    
    if (model.img_h > model.img_w) {
        CGFloat sj_w = 0;
        sj_w = (400.0*K_SCALE)/model.img_h * model.img_w;
        CGFloat offwid = (SCREEN_WIDTH - sj_w)/2+5;
//        NSLog(@"宽高：%f,%f,--shiji::%f,%f",model.img_w,model.img_h,sj_w,400*K_SCALE);
//
//        NSLog(@"比例：：%f--%f",model.img_w/model.img_h,sj_w/(400*K_SCALE));
        
        [self.videoBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(offwid);
            make.right.equalTo(-offwid);
            make.top.equalTo(self.titleLab.bottom);
            make.height.equalTo(400*K_SCALE);
        }];
    }else{

        [self.videoBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(self.titleLab.bottom);
            make.height.equalTo(210*K_SCALE);
        }];
    }
    
    
    self.titleLab.text = model.descriptions;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
}

-(void)handleBtnClick:(UIButton *)sender{
    NSLog(@"点击了：%ld",sender.tag);
    if (self.backBlock) {
        self.backBlock(sender.tag);
    }
}

@end
