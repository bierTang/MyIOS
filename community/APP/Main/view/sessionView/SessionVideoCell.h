//
//  SessionVideoCell.h
//  community
//
//  Created by 蔡文练 on 2019/10/10.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionVideoCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;

@property(nonatomic,strong)UIImageView *videoImg;

@property(nonatomic,strong)UILabel *describLab;

@property (nonatomic,copy) void(^backBlock)(id data);

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(SessionModel *)model index:(NSInteger *)i;
@property (nonatomic,strong)UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END
