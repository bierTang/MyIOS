//
//  GroupMemberCell.h
//  community
//
//  Created by 蔡文练 on 2019/11/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupMemberCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray<UIImageView *> *ImgArr;
@property (nonatomic,strong)NSMutableArray<UILabel *> *LabArr;

@property (nonatomic,strong)UILabel *onlineLab;

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;


-(void)refreshCell:(NSArray *)arr memBerNum:(NSInteger)num;

@end

NS_ASSUME_NONNULL_END
