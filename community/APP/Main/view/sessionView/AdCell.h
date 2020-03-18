//
//  AdCell.h
//  community
//
//  Created by MAC on 2020/3/18.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;

@property (nonatomic,strong)UIImageView *adImg;

@property (nonatomic,copy) void(^adBlock)(id data);

@property (nonatomic,strong)UILabel *timeLabel;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;
-(void)refreshCell:(SessionModel *)model;
@end

NS_ASSUME_NONNULL_END
