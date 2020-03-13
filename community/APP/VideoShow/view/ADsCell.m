//
//  ADsCell.m
//  community
//
//  Created by MAC on 2020/1/15.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "ADsCell.h"

@implementation ADsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"ADsCell";

    ADsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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

    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
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
    
    self.videoBgView = [[UIView alloc]init];
    self.videoBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.videoBgView];

    [self.videoBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.contentLab.bottom).offset(5);
        make.height.equalTo(205*K_SCALE);
//        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    self.videoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"madeOfVideo"]];
    [self.videoBgView addSubview:self.videoImg];
    [self.videoImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
    
    
    UIView *grayView = [[UIView alloc]init];
    [self.contentView addSubview:grayView];
    grayView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.top.equalTo(self.videoBgView.bottom).offset(15);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
}
-(void)refreshData:(VideoModel *)model{
    self.nameLab.text = model.nick_name;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    self.timeLab.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
    self.contentLab.text = model.descriptions;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"madeOfVideo"]];
    
}


@end
