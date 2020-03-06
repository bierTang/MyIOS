//
//  CSChatListCell.h
//  community
//
//  Created by 蔡文练 on 2019/9/4.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSChatListCell : UITableViewCell
@property(nonatomic,strong)UILabel *freeLab;


- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCell:(ChatListModel *)model;

@end

NS_ASSUME_NONNULL_END
