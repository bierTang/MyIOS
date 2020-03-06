//
//  PhotoCell.h
//  community
//
//  Created by 蔡文练 on 2019/10/16.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)UIButton *deleteBtn;

@property (nonatomic,strong)UIView *videoBgView;

@property (nonatomic,copy) void(^deleteBlock)(id data);

-(void)refreshItem:(PickerModel *)model;

@end

NS_ASSUME_NONNULL_END
