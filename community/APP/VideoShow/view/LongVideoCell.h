//
//  LongVideoCell.h
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LongVideoCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *videoImg;
@property (nonatomic,strong)UIButton *showImgBtn;

@property (nonatomic,strong)UIImageView *BlurImg;


@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,copy) void (^backBlock)(NSInteger type);


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshData:(VideoModel *)model;



@end

NS_ASSUME_NONNULL_END
