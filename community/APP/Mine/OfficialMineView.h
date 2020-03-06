//
//  OfficialMineView.h
//  community
//
//  Created by 蔡文练 on 2019/11/8.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfficialMineView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,copy)void (^cellBlock)(id data);


-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
