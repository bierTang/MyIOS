//
//  MyCollectImgCell.h
//  community
//
//  Created by 蔡文练 on 2019/10/22.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainer.h"

NS_ASSUME_NONNULL_BEGIN
#define ItemWidth 112*K_SCALE
@interface MyCollectImgCell : UITableViewCell

@property (nonatomic,strong)UIButton *foldBtn;
@property (nonatomic,strong)UILabel *contentLab;
@property (nonatomic,strong)PhotoContainer *containerView;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,strong)UIImageView *videoBgImg;


@property (nonatomic,copy) void(^backBlock)(id data);
@property (nonatomic,copy) void(^videoBlock)(id data);

@property (nonatomic,assign)BOOL isFold;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshModel:(CityContentModel *)model;


@property (nonatomic,strong)UIView *delView;

@end

NS_ASSUME_NONNULL_END
