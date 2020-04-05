//
//  AdCell.m
//  community
//
//  Created by MAC on 2020/3/18.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "AdCell.h"

@implementation AdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"AdCell";
    AdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_moren"]];
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
    
    self.adImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_icon"]];

    [self.contentView addSubview:self.adImg];
    
    [self.adImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(15);
        make.top.equalTo(37);
        make.width.equalTo(220);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAd:)];
    [self.adImg addGestureRecognizer:tap];
   self.adImg.userInteractionEnabled = YES;
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(30);
        make.height.equalTo(300*K_SCALE);
        make.bottom.equalTo(self.contentView.bottom).offset(-3);
        make.right.equalTo(self.adImg.right).offset(5);
    }];
}

-(void)showAd:(UITapGestureRecognizer *)tap{

    
    if(self.adBlock){
      
        self.adBlock(0);
    }
    
    
}

-(void)refreshCell:(SessionModel *)model{
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
   self.userNameLab.text = model.nick_name;
   [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"head_moren"]];
   __weak typeof(self) wself = self;
     [self.adImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.images]] placeholderImage:[UIImage imageNamed:@"loadNormal"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //        NSLog(@"图片错误：：%@--%ld",error,cacheType);
            if (image.size.height > image.size.width) {
                [self.adImg updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(205*K_SCALE);
                }];
            }else{
                [self.adImg updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(260*K_SCALE);
                }];
            }
            
        }];
}


@end
