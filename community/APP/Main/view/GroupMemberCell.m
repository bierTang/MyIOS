//
//  GroupMemberCell.m
//  community
//
//  Created by 蔡文练 on 2019/11/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "GroupMemberCell.h"

@implementation GroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"GroupMemberCell";
    GroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.ImgArr = [NSMutableArray new];
    self.LabArr = [NSMutableArray new];

    
    for (int i = 0; i<45; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20*K_SCALE+70*K_SCALE*(i%5), 16*K_SCALE+76*K_SCALE*(i/5), 50*K_SCALE, 50*K_SCALE)];
        imageview.image = [UIImage imageNamed:@"headImg_base_2"];
        [self.contentView addSubview:imageview];
        imageview.layer.cornerRadius = 4;
        imageview.clipsToBounds = YES;
        imageview.hidden = YES;
        
        [self.ImgArr addObject:imageview];
        
        UILabel *label= [UILabel labelWithTitle:@"用户名" font:11 textColor:@"6e6e6e" textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview.bottom).offset(2);
            make.centerX.equalTo(imageview.centerX);
            make.width.equalTo(60);
        }];
        label.hidden = YES;
        [self.LabArr addObject:label];
//        if (i==9) {
//            UIImageView *moreimg=[[UIImageView alloc]initWithFrame:imageview.bounds];
//            moreimg.image = [UIImage imageNamed:@"moreMember"];
//            [imageview addSubview:moreimg];
//        }
    }
    
    self.onlineLab = [UILabel labelWithTitle:@"" font:14 textColor:@"6e6e6e" textAlignment:NSTextAlignmentCenter];
//    self.onlineLab.frame = CGRectMake(0, 150*K_SCALE, SCREEN_WIDTH, 50);
    [self.contentView addSubview:self.onlineLab];
    [self.onlineLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(690*K_SCALE);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(50);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    
}

-(void)refreshCell:(NSArray *)arr memBerNum:(NSInteger)num {
    NSInteger max = 45;
    if (arr.count < 45) {
        max = arr.count;
    }
    for (int i=0; i<max; i++) {
        UserModel *model = arr[i];
        self.ImgArr[i].hidden = NO;
        self.LabArr[i].hidden = NO;
        if (i == max-1) {
            self.LabArr[i].text = @"";
            self.ImgArr[i].image = [UIImage imageNamed:@"moreMember"];
            
        }else{
            self.LabArr[i].text = model.nickname;
            [self.ImgArr[i] sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"headImg_base_3"]];
        }
    }
    
    self.onlineLab.text = [NSString stringWithFormat:@"群成员（%ld）",num];
//    [self.onlineLab updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo((num/5)*75*K_SCALE);
//        make.centerX.equalTo(self.contentView.centerX);
//        make.width.equalTo(self.contentView.width);
//        make.height.equalTo(50);
//        make.bottom.equalTo(self.contentView.bottom);
//    }];
}


@end
