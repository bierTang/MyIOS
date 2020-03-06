//
//  ShareRecordCell.h
//  community
//
//  Created by 蔡文练 on 2019/11/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareRecordCell : UITableViewCell

@property (nonatomic,strong)UILabel *phoneLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *leftTime;



- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;


-(void)refreshCell:(CSRecordModel *)model;


@end

NS_ASSUME_NONNULL_END
