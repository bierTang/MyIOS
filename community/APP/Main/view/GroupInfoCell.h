//
//  GroupInfoCell.h
//  community
//
//  Created by 蔡文练 on 2019/11/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupInfoCell : UITableViewCell

@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)UILabel *subTitle;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(NSString *)name subtitle:(NSString *)subTitle showArrow:(BOOL )arrow;


@end

NS_ASSUME_NONNULL_END
