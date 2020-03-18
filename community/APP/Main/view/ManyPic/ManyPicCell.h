//
//  ManyPicCell.h
//  community
//
//  Created by MAC on 2019/12/24.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManyPicCell : UITableViewCell <MLEmojiLabelDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)MLEmojiLabel *describLab;

@property (nonatomic,strong)NSMutableArray<UIImageView *> *imgArr;
@property (nonatomic,strong)NSArray *imgURLArr;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(SessionModel *)model;

@property (nonatomic,copy) void(^backBlock)(id data);
@property (nonatomic,strong)UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END
