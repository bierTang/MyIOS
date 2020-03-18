//
//  SessionImgCell.h
//  community
//
//  Created by 蔡文练 on 2019/9/30.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionImgCell : UITableViewCell <MLEmojiLabelDelegate>

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property (nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)UIImageView *bgImg;

@property(nonatomic,strong)UIImageView *Img;
@property(nonatomic,strong)MLEmojiLabel *describLab;

@property (nonatomic,copy) void(^backBlock)(id data);
@property (nonatomic,strong)UITapGestureRecognizer *tap;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(SessionModel *)model;
@property (nonatomic,strong)UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END
