//
//  ADsCell.h
//  community
//
//  Created by MAC on 2020/1/15.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADsCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,strong)UIImageView *videoImg;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshData:(VideoModel *)model;


@end

NS_ASSUME_NONNULL_END
