//
//  GroupInfoCell.m
//  community
//
//  Created by 蔡文练 on 2019/11/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "GroupInfoCell.h"

@implementation GroupInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"GroupInfoCell";
    GroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.nameLab = [UILabel labelWithTitle:@"名" font:14 textColor:@"181818" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLab];
    
    [self.nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    self.arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:self.arrowImg];
    
    [self.arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    
    self.subTitle = [UILabel labelWithTitle:@"ff" font:15 textColor:@"6E6E6E" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.subTitle];
    
    [self.subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.left).offset(-5);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

-(void)refreshCell:(NSString *)name subtitle:(NSString *)subTitle showArrow:(BOOL)arrow{
    self.nameLab.text = name;
    self.subTitle.text = subTitle;
    if (subTitle.length > 0) {
        self.arrowImg.hidden = YES;
    }else{
        self.arrowImg.hidden = NO;
    }
//    self.arrowImg.hidden = !arrow;
}



@end
