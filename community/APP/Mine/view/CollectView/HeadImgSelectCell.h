//
//  HeadImgSelectCell.h
//  community
//
//  Created by MAC on 2020/1/17.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadImgSelectCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UIButton *selectBtn;


@property (nonatomic,copy) void (^ headImgSelectBlock)(NSString *data);

-(void)refreshItem:(NSInteger)index andIsSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
