//
//  TextReadCell.m
//  community
//
//  Created by MAC on 2019/12/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "TextReadCell.h"

@implementation TextReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"TextReadCell";
    TextReadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
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
    
    self.txtIconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_icon"]];

    [self.contentView addSubview:self.txtIconImg];
    
    [self.txtIconImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(15);
        make.top.equalTo(37);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
    
    self.titleLab = [UILabel labelWithTitle:@"小说名.txt" font:16*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txtIconImg.centerY);
        make.left.equalTo(self.txtIconImg.right).offset(7);
        make.width.lessThanOrEqualTo(180*K_SCALE);
    }];
    
    
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(30);
        make.bottom.equalTo(self.contentView.bottom).offset(-3);
        make.right.equalTo(self.titleLab.right).offset(15);
    }];
}

-(void)refreshCell:(SessionModel *)model{
    self.timeLabel.text = [HelpTools distanceTimeWithBeforeTime:[model.create_time floatValue]];
      self.userNameLab.text = model.nick_name;
      [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"1"]];
    self.titleLab.text = [model.name stringByAppendingString:@".txt"];
}

@end
