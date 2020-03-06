//
//  RecordCell.m
//  community
//
//  Created by 蔡文练 on 2019/11/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"RecordCell";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.timeLab = [UILabel labelWithTitle:@"" font:11*K_SCALE textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLab];
    
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
    }];
    
    self.coinLab = [UILabel labelWithTitle:@"" font:14*K_SCALE textColor:@"09c66a" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.coinLab];
    
    [self.coinLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.timeLab.centerY);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0.5);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(self.timeLab.bottom).offset(10);
    }];
    
    self.typeLab = [UILabel labelWithTitle:@"" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.typeLab];
    [self.typeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(line.bottom).offset(12);
    }];
    
    self.contentLab = [UILabel labelWithTitle:@"" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.contentLab];
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.typeLab.bottom).offset(12);
    }];
    
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.contentView addSubview:sepView];
    [sepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(8);
        make.bottom.equalTo(self.contentView.bottom);
        make.top.equalTo(self.contentLab.bottom).offset(12);
    }];
}


-(void)refreshCell:(CSRecordModel *)model{
    
    self.timeLab.text = [HelpTools dateStampWithTime:model.create_time.integerValue andFormat:@"YYYY-MM-dd  hh:mm:ss"];//@"2019-10-01";
    NSString *str = model.type == 1 ? @"+":@"-";
    if (model.type == 1) {
        self.coinLab.textColor = [UIColor redColor];
    }else{
        self.coinLab.textColor = [UIColor colorWithHexString:@"09c66a"];
    }
    self.coinLab.text = [NSString stringWithFormat:@"%@%@",str,model.coin];
    self.typeLab.text = model.exchange_type;//@"交易类型";
    self.contentLab.text = model.descriptions;//@"购买";
}

@end
