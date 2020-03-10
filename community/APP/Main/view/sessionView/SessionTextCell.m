//
//  SessionTextCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/10.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "SessionTextCell.h"

@implementation SessionTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"SessionTextCell";
    SessionTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.bgImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImg];
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
    [self.contentView addSubview:self.headImg];
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(2);
        make.height.width.equalTo(34);
    }];
    
    self.userNameLab = [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(self.headImg.top).offset(3);
    }];
    
    UIImage *img = [UIImage imageNamed:@"chatBgImg"];
    // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(25, 15, 8, 8) resizingMode:UIImageResizingModeStretch];
    self.bgImg.image = img;
    
    self.describLab = [MLEmojiLabel new];
    self.describLab.delegate = self;
    self.describLab.font = [UIFont systemFontOfSize:14];
    self.describLab.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    [UILabel labelWithTitle:@"" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.describLab.numberOfLines = 0;
    [self.contentView addSubview:self.describLab];
    
    [self.describLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(12);
        make.top.equalTo(25);
        make.right.lessThanOrEqualTo(-50);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(5);
        make.top.equalTo(23);
        make.bottom.equalTo(self.describLab.bottom).offset(3);
        make.right.equalTo(self.describLab.right).offset(3);
    }];
}
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    
    if (![link hasPrefix:@"http"]) {
        link = [NSString stringWithFormat:@"http://%@",link];
    }
    if (link.length > 5 && ([link containsString:@"www"]||[link containsString:@"http"])) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link]];
        }
    }
}

-(void)refreshCell:(SessionModel *)model{
  self.userNameLab.text = model.nick_name;
  [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,model.user_avatar]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
//    if (model.descriptions.length > 0) {
        self.describLab.text = model.descriptions;
//    }
    
}


@end
