//
//  CSChatRoomCell.m
//  community
//
//  Created by 蔡文练 on 2019/9/4.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSChatRoomCell.h"

@interface CSChatRoomCell()

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameLab;

@end


@implementation CSChatRoomCell

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"CSChatRoomCell";
    CSChatRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 6, 34, 34)];
    [self.contentView addSubview:self.headImg];
    self.headImg.image = [UIImage imageNamed:@"headImg_base"];
    
    self.nameLab = [UILabel labelWithTitle:@"群名称" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    self.nameLab.frame = CGRectMake(68, 0, 200, 47);
    [self.contentView addSubview:self.nameLab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(68, 46,SCREEN_WIDTH - 68, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.contentView addSubview:line];
}

@end
