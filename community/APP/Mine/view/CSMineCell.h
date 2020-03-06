//
//  CSMineCell.h
//  community
//
//  Created by 蔡文练 on 2019/9/7.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSMineCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *arrowImg;

@property (nonatomic,strong)UILabel *subTitle;

@property (nonatomic,strong)UIButton *funcBtn;

@property (nonatomic,strong)UILabel *messageLab;

@property (nonatomic,copy) void (^BtnBlock)(void);

- (instancetype)cellInitWith:(UITableView *)tableView Indexpath:(NSIndexPath *)indexPath;

-(void)refreshCellIcon:(NSString *)iconName andTitle:(NSString *)title subtitle:(NSString *)subTitle funBtnTitle:(NSString *)btnTitle;
-(void)messageText:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
