//
//  CSMineHeaderCell.h
//  community
//
//  Created by 蔡文练 on 2019/9/7.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSMineHeaderCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImg;

@property (nonatomic,strong)UILabel *nameLab;

@property (nonatomic,strong)UILabel *IdLab;

@property (nonatomic,strong)UIButton *reviseBtn;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshInfo:(UserModel *)model;
@end

NS_ASSUME_NONNULL_END
