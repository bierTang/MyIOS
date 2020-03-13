//
//  CSChatListCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/4.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSChatListCell.h"

@interface CSChatListCell()

@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UILabel *timeLab;

@property(nonatomic,strong)UIImageView *diamondImg;

@property(nonatomic,strong)UILabel *priceLabel;

@end

@implementation CSChatListCell


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSChatListCell";
    CSChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.headImg.layer.cornerRadius = 4;
    self.headImg.clipsToBounds = YES;
    [self.contentView addSubview:self.headImg];
    
    CGFloat kk = K_SCALE;
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(40*kk);
        make.left.equalTo(16);
        make.top.equalTo(13*kk);
    }];
    
    self.headImg.image = [UIImage imageNamed:@"headImg_base"];
    
    self.nameLab = [UILabel labelWithTitle:@"名字" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
//    self.nameLab.frame = CGRectMake(65, 17.5, 250, 18);
    [self.contentView addSubview:self.nameLab];
    
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(65*kk);
        make.top.equalTo(17*kk);
        make.height.equalTo(18*kk);
    }];
    
    ///
    self.diamondImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond_icon"]];
    [self.contentView addSubview:self.diamondImg];
    [self.diamondImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.right).offset(10);
        make.centerY.equalTo(self.nameLab.centerY);
    }];
    
    self.priceLabel = [UILabel labelWithTitle:@"" font:11*K_SCALE textColor:@"e9c14f" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.diamondImg.right).offset(6);
        make.centerY.equalTo(self.diamondImg.centerY);
    }];
    if ([UserTools isAgentVersion]) {
        self.priceLabel.hidden = YES;
    }
    
    self.contentLab = [UILabel labelWithTitle:@"最近的聊天内容" font:11*K_SCALE textColor:@"999999" textAlignment:NSTextAlignmentLeft];
    self.contentLab.frame = CGRectMake(65*kk, 40*kk, 255*K_SCALE, 18*kk);
    [self.contentView addSubview:self.contentLab];
    
    self.timeLab = [UILabel labelWithTitle:@"刚刚" font:10*K_SCALE textColor:@"9b9b9b" textAlignment:NSTextAlignmentRight];
    self.timeLab.frame = CGRectMake(SCREEN_WIDTH-116, 0, 100, 50*kk);
    [self.contentView addSubview:self.timeLab];
    
    
    self.freeLab = [UILabel labelWithTitle:@"免费" font:11*K_SCALE textColor:@"09c66a" textAlignment:NSTextAlignmentRight];
    self.freeLab.hidden = YES;
    self.freeLab.frame = CGRectMake(SCREEN_WIDTH-116, 40*kk, 100, 18*kk);
    [self.contentView addSubview:self.freeLab];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(65*kk, 59.5*kk,SCREEN_WIDTH - 64*kk, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:line];
    
    UIView *gray = [[UIView alloc]initWithFrame:CGRectMake(0, 60.1*kk, SCREEN_WIDTH, 10*kk)];
    gray.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:gray];
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

-(void)refreshCell:(ChatListModel *)model{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@" ,mainHost,model.path]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    self.nameLab.text = model.name;
    self.timeLab.text = [HelpTools distanceTimeWithBeforeTime:[model.update_time floatValue]];
    
    
    NSArray *arr = @[@"图片",@"视频",@"文字",@"未知类型",@"未知类型",@"未知类型",@""];
    self.contentLab.text = arr[model.type];
    if (model.type == 2) {
        self.contentLab.text = model.message;
    }
    self.freeLab.hidden = YES;
    if ([HelpTools isMemberShip]) {
        self.diamondImg.hidden = YES;
        self.priceLabel.text = @"";
    }else if(model.group_allow){
        self.diamondImg.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"剩余时间:%@",model.life_expiration];
    }else if(model.need_coin > 0){
        self.diamondImg.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"%ld金币",model.need_coin];
    }else{
        self.diamondImg.hidden = YES;
        self.priceLabel.text = @"";
    }
    
}


@end
