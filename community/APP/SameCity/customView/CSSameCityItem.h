//
//  CSSameCityItem.h
//  community
//
//  Created by 蔡文练 on 2019/9/6.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSameCityItem : UICollectionViewCell

@property (nonatomic,strong)UILabel *postNum_Lab;
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *provinceLab;

//@property (nonatomic,strong)UILabel *numLab;



-(void)refreshItem:(CityListModel *)model;
    
    
@end

NS_ASSUME_NONNULL_END
