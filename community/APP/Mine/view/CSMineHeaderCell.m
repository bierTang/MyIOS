//
//  CSMineHeaderCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/7.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSMineHeaderCell.h"

@implementation CSMineHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSMineHeaderCell";
    CSMineHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.headImg.clipsToBounds =YES;
    
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(60);
        make.height.width.equalTo(60);
    }];
    
    self.nameLab = [UILabel labelWithTitle:@"请先登录" font:20 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(20);
        make.top.equalTo(self.headImg.top);
        make.height.equalTo(35);
        make.width.lessThanOrEqualTo(200);
    }];
    
    self.IdLab = [UILabel labelWithTitle:@"ID:" font:11 textColor:@"666666" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.IdLab];
    
    [self.IdLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImg.bottom);
        make.left.equalTo(self.nameLab.left);
        make.height.equalTo(35);
    }];
    
//    self.reviseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.reviseBtn setImage:[UIImage imageNamed:@"revise_btn"] forState:UIControlStateNormal];
//
//    [self.reviseBtn addTarget:self action:@selector(reviseNickName) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.reviseBtn];
//
//    [self.reviseBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.nameLab.centerY);
//        make.left.equalTo(self.nameLab.right).offset(15);
//    }];
    
    
    self.iconBtn1 = [UIButton buttonWithTitle:@"" font:12 titleColor:@"ffffff"];
    [self.iconBtn1 setBackgroundImage:[UIImage imageNamed:@"mine_icon1"] forState:UIControlStateNormal];
//    self.funcBtn.layer.cornerRadius = 4;
//    self.funcBtn.clipsToBounds = YES;
//    [self.funcBtn addTarget:self action:@selector(handleBtnCliecked:) forControlEvents:UIControlEventTouchUpInside];
//    self.funcBtn.hidden = YES;
    [self.contentView addSubview:self.iconBtn1];
    
    [self.iconBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(140);
//        make.centerY.equalTo(self.centerY);
        make.height.equalTo(56);
        make.width.equalTo(SCREEN_WIDTH/2 - 20);
    }];
    
    
    UILabel *label1 = [UILabel labelWithTitle:@"ID:" font:14 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    label1.text = @"卡密激活";
    [self.iconBtn1 addSubview:label1];
    
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBtn1);
        make.left.equalTo(13);
    }];
    
    
    UILabel *label11 = [UILabel labelWithTitle:@"ID:" font:11 textColor:@"09c76a" textAlignment:NSTextAlignmentCenter];
    label11.text = @"激活";
    label11.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    label11.layer.cornerRadius = 10;
    label11.clipsToBounds = YES;
    [self.iconBtn1 addSubview:label11];
    
    [label11 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBtn1);
        make.right.equalTo(-13);
        make.width.equalTo(43);
        make.height.equalTo(21);
    }];
    
    
    self.iconBtn2 = [UIButton buttonWithTitle:@"" font:12 titleColor:@"ffffff"];
        [self.iconBtn2 setBackgroundImage:[UIImage imageNamed:@"mine_icon2"] forState:UIControlStateNormal];
    //    self.funcBtn.layer.cornerRadius = 4;
    //    self.funcBtn.clipsToBounds = YES;
    //    [self.funcBtn addTarget:self action:@selector(handleBtnCliecked:) forControlEvents:UIControlEventTouchUpInside];
    //    self.funcBtn.hidden = YES;
        [self.contentView addSubview:self.iconBtn2];
        
        [self.iconBtn2 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.top.equalTo(140);
            make.height.equalTo(56);
            make.width.equalTo(SCREEN_WIDTH/2 - 20);
        }];
    
    
    UILabel *label2 = [UILabel labelWithTitle:@"ID:" font:14 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    label2.text = @"卡密购买";
    [self.iconBtn2 addSubview:label2];
    
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBtn1);
        make.left.equalTo(13);
    }];
    
    
    UILabel *label22 = [UILabel labelWithTitle:@"ID:" font:11 textColor:@"09c76a" textAlignment:NSTextAlignmentCenter];
    label22.text = @"购买";
    label22.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    label22.layer.cornerRadius = 10;
    label22.clipsToBounds = YES;
    [self.iconBtn2 addSubview:label22];
    
    [label22 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBtn1);
        make.right.equalTo(-13);
        make.width.equalTo(43);
        make.height.equalTo(21);
    }];
    if (![UserTools isAgentVersion]) {
        self.iconBtn1.hidden = YES;
        self.iconBtn2.hidden = YES;
    }
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImg.centerY);
        make.right.equalTo(-16);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [self.contentView addSubview:addBtn];
       [addBtn setImage:[UIImage imageNamed:@"service_nav"] forState:UIControlStateNormal];
       [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
       [addBtn makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(15);
           make.right.equalTo(-16);
       }];
    if ([UserTools isAgentVersion]) {
        addBtn.hidden = YES;
    }
}
-(void)addBtnEvent{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myViewEnterServeWeb" object:nil];
}


-(void)refreshInfo:(UserModel *)model{
    if (model) {
//        [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
        if (model.avatar.integerValue > 0) {
            self.headImg.image = [UIImage imageNamed:model.avatar];
        }else{
            self.headImg.image = [UIImage imageNamed:@"1"];
        }
        self.IdLab.text = [NSString stringWithFormat:@"ID:%@",model.idss];
        self.nameLab.text = model.nickname;
    }else{
        self.headImg.image = [UIImage imageNamed:@"headImg_base"];
        self.IdLab.text = @"ID:";
        self.nameLab.text = @"未登录";
    }
    
}
//
//-(void)reviseNickName{
//    NSLog(@"修改昵称");
//}


@end
