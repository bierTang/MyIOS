//
//  MadeOfCell.h
//  community
//
//  Created by MAC on 2020/1/7.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "微群社区-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface MadeOfCell : UITableViewCell

@property (nonatomic, readonly) NSInteger coverTag;

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *contentLab;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,strong)UIImageView *BlurImg;

@property (nonatomic,strong)UIImageView *videoImg;

@property (nonatomic,strong)VideoModel *model;

//@property (nonatomic,copy)NSString *postId;
//@property (nonatomic,copy)NSString *requstStr;

@property (nonatomic,strong)UILabel *collectNumLab;
@property (nonatomic,strong)UILabel *praiseNumLab;

@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,strong)UIButton *praiseBtn;

@property (nonatomic,copy) void (^videoBlock)(NSInteger type);

@property (nonatomic,copy) void (^keepBlock)(UIButton *sender);

@property (nonatomic,copy) void (^laudBlock)(UIButton *sender);

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshData:(VideoModel *)model;
@property (nonatomic,strong)NoVipView *noVipView;


@end

NS_ASSUME_NONNULL_END
