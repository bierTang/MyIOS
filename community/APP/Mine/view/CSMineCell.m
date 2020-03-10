//
//  CSMineCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/7.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSMineCell.h"

@implementation CSMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSMineCell";
    CSMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.iconImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconImg];
    [self.iconImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(self.centerY);
    }];
    
    
    self.titleLab = [UILabel labelWithTitle:@"" font:16 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(52);
        make.centerY.equalTo(self.centerY);
    }];
    
    ////账号的label
    self.messageLab = [UILabel labelWithTitle:@"" font:14 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.messageLab];
    
    [self.messageLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-120);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:self.arrowImg];
    
    [self.arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.centerY);
    }];
    
    
    self.subTitle = [UILabel labelWithTitle:@"" font:15 textColor:@"6e6e6e" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.subTitle];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.left).offset(-5);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.funcBtn = [UIButton buttonWithTitle:@"" font:12 titleColor:@"ffffff"];
    [self.funcBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"08c567"]] forState:UIControlStateNormal];
    self.funcBtn.layer.cornerRadius = 4;
    self.funcBtn.clipsToBounds = YES;
    [self.funcBtn addTarget:self action:@selector(handleBtnCliecked:) forControlEvents:UIControlEventTouchUpInside];
    self.funcBtn.hidden = YES;
    [self.contentView addSubview:self.funcBtn];
    
    [self.funcBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(self.centerY);
        make.height.equalTo(22);
        make.width.equalTo(44);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.left);
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.height.equalTo(0.5);
    }];
    
    
}
-(void)handleBtnCliecked:(UIButton *)sender{
    NSLog(@"handleeeeeeeeeeeeeeeeeee");
    if (self.BtnBlock) {
        self.BtnBlock();
    }
}
-(void)refreshCellIcon:(NSString *)iconName andTitle:(NSString *)title subtitle:(nonnull NSString *)subTitle funBtnTitle:(nonnull NSString *)btnTitle{
    self.iconImg.image = [UIImage imageNamed:iconName];
    self.titleLab.text = title;
    self.subTitle.text = subTitle;
    
    if (([subTitle containsString:@"-"])||([title containsString:@"金币"])) {
        self.arrowImg.hidden = YES;
    }
    
    if (btnTitle.length > 0) {
//        self.arrowImg.hidden = YES;
        
        self.funcBtn.hidden = NO;
        
        [self.funcBtn setTitle:btnTitle forState:UIControlStateNormal];
    }else{
        self.funcBtn.hidden = YES;
        
        [self.funcBtn setTitle:btnTitle forState:UIControlStateNormal];
    }
}

-(void)messageText:(NSString *)message{
    self.messageLab.text = message;
}

@end
