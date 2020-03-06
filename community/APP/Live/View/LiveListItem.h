//
//  LiveListItem.h
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListItem : UICollectionViewCell

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)UILabel *onlineNum;
@property (nonatomic,strong)UIImageView *onlineIcon;
@property (nonatomic,strong)UILabel *cityLabel;
@property (nonatomic,strong)UIImageView *cityImg;
-(void)refreshItem:(LiveModel *)model;

@end

NS_ASSUME_NONNULL_END
