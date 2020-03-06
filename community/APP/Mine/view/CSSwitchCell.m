//
//  CSSwitchCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/17.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSSwitchCell.h"

@implementation CSSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSSwitchCell";
    CSSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    
    self.titleLab = [UILabel labelWithTitle:@"标题" font:12 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.swt = [[UISwitch alloc]init];
    [self.contentView addSubview:self.swt];
    
    [self.swt makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.centerY);
    }];
    
}


@end
