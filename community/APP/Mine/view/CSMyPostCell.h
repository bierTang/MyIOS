//
//  CSMyPostCell.h
//  community
//
//  Created by 蔡文练 on 2019/10/31.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSMyPostCell : UITableViewCell

@property (nonatomic,strong)UILabel *dayLabel;
@property (nonatomic,strong)UILabel *monthLabel;
@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)UIButton *foldBtn;
@property (nonatomic,strong)PhotoContainer *containerView;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,strong)UIButton *delBtn;


@property (nonatomic,copy) void(^backBlock)(id data);
@property (nonatomic,copy) void(^videoBlock)(id data);

@property (nonatomic,assign)BOOL isFold;

@property (nonatomic,copy)NSString *postId;

@property (nonatomic,strong)UILabel *statusLab;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(CityContentModel *)model;


@end

NS_ASSUME_NONNULL_END
