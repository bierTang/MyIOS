//
//  MadeOfCell.m
//  community
//
//  Created by MAC on 2020/1/7.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "MadeOfCell.h"

@implementation MadeOfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"MadeOfCell";
//    self.tableview = tableView;
    MadeOfCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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

    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_moren"]];
    [self.contentView addSubview:self.headImg];
    self.headImg.layer.cornerRadius = 4;
    self.headImg.clipsToBounds = YES;
    
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
        make.width.height.equalTo(40);
    }];
    
    self.nameLab = [UILabel labelWithTitle:@"名字" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
        make.right.equalTo(-15);
    }];
    
    self.timeLab = [UILabel labelWithTitle:@"15分钟前" font:10 textColor:@"9b9b9b" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLab];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.left);
        make.bottom.equalTo(self.headImg.bottom).offset(-3);
    }];
    
    self.contentLab = [UILabel labelWithTitle:@"哈哈" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.contentLab];
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.left);
        make.top.equalTo(self.headImg.bottom).offset(5);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.height.lessThanOrEqualTo(60);
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
    self.videoBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.videoBgView];
//    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
//    [self.videoBgView addGestureRecognizer:playTap];
    [self.videoBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.contentLab.bottom).offset(5);
        make.height.equalTo(210*K_SCALE);
//        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.BlurImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.videoBgView.top);
        make.bottom.equalTo(self.videoBgView.bottom);
    }];
    
    self.videoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
    [self.videoBgView addSubview:self.videoImg];
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.tag = 99;
    [playBtn setImage:[UIImage imageNamed:@"playBtn_icon"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playingVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBgView addSubview:playBtn];
    [playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoBgView.center);
    }];
    UIButton *clickBtn = [UIButton buttonWithTitle:@"精彩缩略图" font:14 titleColor:@"999999"];
       [clickBtn addTarget:self action:@selector(playingVideo:) forControlEvents:UIControlEventTouchUpInside];
       [self.contentView addSubview:clickBtn];
       clickBtn.tag =2;
       [clickBtn makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.videoBgView.bottom);
//           make.centerX.equalTo(self.contentView.centerX);
           make.left.equalTo(40);
           make.width.equalTo(200);
           make.height.equalTo(44*K_SCALE);
       }];
    self.collectNumLab = [UILabel labelWithTitle:@"0" font:11 textColor:@"9b9b9b" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.collectNumLab];

    [self.collectNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.top.equalTo(self.videoBgView.bottom).offset(14);
    }];

    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setImage:[UIImage imageNamed:@"collect_gray"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"collect_hover"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.collectBtn];
    [self.collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectNumLab.centerY);
        make.right.equalTo(self.collectNumLab.left).offset(-5);
        make.height.equalTo(40);
    }];

    self.praiseNumLab = [UILabel labelWithTitle:@"0" font:11 textColor:@"9b9b9b" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.praiseNumLab];

    [self.praiseNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectBtn.left).offset(-35);
        make.centerY.equalTo(self.collectNumLab.centerY);
    }];
    
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praiseIcon"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praise_hover"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.praiseBtn];
    [self.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.collectNumLab.centerY);
        make.right.equalTo(self.praiseNumLab.left).offset(-5);
        make.height.equalTo(40);
    }];
    
    UIView *grayView = [[UIView alloc]init];
    [self.contentView addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.top.equalTo(self.praiseNumLab.bottom).offset(15);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    
    self.noVipView = [[ NoVipView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210*K_SCALE)];
    [self.contentView addSubview:self.noVipView];
    self.noVipView.hidden = YES;
    [self.noVipView makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(0);
           make.right.equalTo(0);
           make.top.bottom.equalTo(self.videoBgView);
           
       }];
    self.noVipView.bt1.tag = 3;
    [self.noVipView.bt1 addTarget:self action:@selector(playingVideo:) forControlEvents:UIControlEventTouchUpInside];
    self.noVipView.bt2.tag = 4;
    [self.noVipView.bt2 addTarget:self action:@selector(playingVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)refreshData:(VideoModel *)model{
    self.noVipView.hidden = YES;
    self.model = model;
    
    self.nameLab.text = model.nick_name;
    [self.BlurImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default"]];
    if (model.img_h > model.img_w) {
        CGFloat sj_w = 0;
        sj_w = (400.0*K_SCALE)/model.img_h * model.img_w;
        CGFloat offwid = (SCREEN_WIDTH - sj_w)/2;
//        NSLog(@"宽高：%f,%f,--shiji::%f,%f",model.img_w,model.img_h,sj_w,400*K_SCALE);
//        
//        NSLog(@"比例：：%f--%f",model.img_w/model.img_h,sj_w/(400*K_SCALE));
        
        [self.videoBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(offwid);
            make.right.equalTo(-offwid);
            make.top.equalTo(self.contentLab.bottom).offset(5);
            make.height.equalTo(400*K_SCALE);
        }];
//        [self.videoBgView remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(30*K_SCALE);
//            make.right.equalTo(-30*K_SCALE);
//            make.top.equalTo(self.contentLab.bottom).offset(5);
//            make.height.equalTo(400*K_SCALE);
//        }];
    }else{

        [self.videoBgView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(self.contentLab.bottom).offset(5);
            make.height.equalTo(210*K_SCALE);
        }];
    }
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"head_moren"]];
    self.timeLab.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    self.contentLab.text = model.descriptions;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    self.collectNumLab.text = self.model.favorite_num;
    self.praiseNumLab.text = self.model.like_num;
    if ([self.model.is_like  isEqual: @"1"]) {
        self.praiseBtn.selected = YES;
    }else{
        self.praiseBtn.selected = NO;
    }
    if ([self.model.is_favorite  isEqual: @"1"]) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }
    
}
-(void)playingVideo:(UIButton *)sender{
    
    if (self.videoBlock) {
        self.videoBlock(sender.tag);
    }
    
}
//-(void)playVideo{
//
//}
//
//
-(void)collectAction:(UIButton *)sender{
    if (![UserTools isLogin]) {
        [[MYToast makeText:@"未登录"]show];
        return;
    }
    
    if (self.keepBlock) {
           self.keepBlock(sender);
       }
    
    
    
//    sender.selected = !sender.isSelected;
//    NSLog(@"收藏");
////
//    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/video_is_favorite" Params:@{@"user_id":[UserTools userID],@"post_id":self.model.idss} Callback:^(BOOL isSuccess, id result) {
//        NSLog(@"加入收藏：：%@--%@",result,result[@"msg"]);
//    } HttpMethod:AppRequestPost isAni:YES];
//
//    self.model.is_favorite = sender.isSelected;
//    if (sender.isSelected) {
//        self.model.favorite_num = [NSString stringWithFormat:@"%ld",self.model.favorite_num.integerValue+1];
//    }else{
//        self.model.favorite_num = [NSString stringWithFormat:@"%ld",self.model.favorite_num.integerValue-1];
//    }
//    self.collectNumLab.text = self.model.favorite_num;
}

-(void)praiseAction:(UIButton *)sender{
    if (![UserTools isLogin]) {
        [[MYToast makeText:@"未登录"]show];
        return;
    }
    
    if (self.laudBlock) {
              self.laudBlock(sender);
          }
    
    
//    sender.selected = !sender.isSelected;
//    
//    self.model.is_like = sender.isSelected;
//
//    if (sender.isSelected) {
//        self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue+1];
//    }else{
//        self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue-1];
//    }
//    self.praiseNumLab.text = self.model.like_num;
//
//    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/video_is_like" Params:@{@"user_id":[UserTools userID],@"post_id":self.model.idss} Callback:^(BOOL isSuccess, id result) {
//        NSLog(@"点赞：：%@",result);
//    } HttpMethod:AppRequestPost isAni:YES];

}

@end
