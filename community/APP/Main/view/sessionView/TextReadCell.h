//
//  TextReadCell.h
//  community
//
//  Created by MAC on 2019/12/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextReadCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIImageView *txtIconImg;
@property (nonatomic,strong)UILabel *titleLab;


@property (nonatomic,strong)UILabel *timeLabel;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;
-(void)refreshCell:(SessionModel *)model;

@end

NS_ASSUME_NONNULL_END
