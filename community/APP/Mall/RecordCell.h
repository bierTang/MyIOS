//
//  RecordCell.h
//  community
//
//  Created by 蔡文练 on 2019/11/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordCell : UITableViewCell

@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *coinLab;

///交易类型
@property (nonatomic,strong)UILabel *typeLab;
///交易内容--购买月卡
@property (nonatomic,strong)UILabel *contentLab;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;


-(void)refreshCell:(CSRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
