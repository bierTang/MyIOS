//
//  PhotoContainer.h
//  community
//
//  Created by 蔡文练 on 2019/11/1.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoContainCell.h"
#import "SDPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoContainer : UIView <UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>

@property (nonatomic,strong)UICollectionView *collectview;

@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,assign)CGSize itemSize;


- (instancetype)initWithSize:(CGSize)size;

-(void)refreshData:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
