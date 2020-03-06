//
//  LoginOutCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/31.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "LoginOutCell.h"

@implementation LoginOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"LoginOutCell";
    LoginOutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    UILabel *lab = [UILabel labelWithTitle:@"安全退出" font:14*K_SCALE textColor:@"ff0000" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:lab];
    [lab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

@end
