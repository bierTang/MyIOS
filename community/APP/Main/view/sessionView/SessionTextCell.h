//
//  SessionTextCell.h
//  community
//
//  Created by 蔡文练 on 2019/10/10.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionTextCell : UITableViewCell <MLEmojiLabelDelegate>

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *userNameLab;

@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)MLEmojiLabel *describLab;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(SessionModel *)model;


@end

NS_ASSUME_NONNULL_END
