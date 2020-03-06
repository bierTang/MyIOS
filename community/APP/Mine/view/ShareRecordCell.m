//
//  ShareRecordCell.m
//  community
//
//  Created by 蔡文练 on 2019/11/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "ShareRecordCell.h"

@implementation ShareRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"ShareRecordCell";
    ShareRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.phoneLab = [UILabel labelWithTitle:@"xxx" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.phoneLab];
    
    [self.phoneLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(18);
    }];
    
    self.timeLab = [UILabel labelWithTitle:@"注册" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLab];
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.phoneLab.bottom).offset(10);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(self.timeLab.bottom).offset(10);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    self.leftTime = [UILabel labelWithTitle:@"3天" font:14 textColor:@"09c66a" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.leftTime];
    [self.leftTime makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
}

-(void)refreshCell:(CSRecordModel *)model{
    self.leftTime.text = [NSString stringWithFormat:@"%@天",model.day_time];
    
    NSString *numberString = [model.name stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"***"];
    self.phoneLab.text = numberString;
    self.timeLab.text = [HelpTools dateStampWithTime:model.create_time.integerValue andFormat:@"YYYY-MM-dd 注册"];
}

@end
