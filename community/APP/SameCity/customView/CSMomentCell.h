//
//  CSMomentCell.h
//  community
//
//  Created by 蔡文练 on 2019/9/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSMomentCell : UITableViewCell

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)UIButton *foldBtn;
//@property (nonatomic,strong)ZJUnFoldView *foldView;

@property (nonatomic,strong)PhotoContainer *containerView;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,strong)UIButton *shareBtn;
@property (nonatomic,strong)UIButton *starBtn;

@property (nonatomic,strong)UILabel *collectNumLab;
@property (nonatomic,strong)UILabel *praiseNumLab;


@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,strong)UIButton *praiseBtn;

@property (nonatomic,copy) void(^backBlock)(id data);
@property (nonatomic,copy) void(^videoBlock)(id data);

@property (nonatomic,assign)BOOL isFold;

@property (nonatomic,strong)CityContentModel *model;

@property (nonatomic,copy)NSString *postId;
@property (nonatomic,copy)NSString *requstStr;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;


//-(void)refreshCell:(CityContentModel *)model;

@end

NS_ASSUME_NONNULL_END
