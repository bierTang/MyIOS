//
//  PhotoContainCell.h
//  community
//
//  Created by 蔡文练 on 2019/11/1.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoContainCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *image;


-(void)refreshImage:(NSString *)imagePath;

@end

NS_ASSUME_NONNULL_END
