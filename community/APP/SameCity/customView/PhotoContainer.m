//
//  PhotoContainer.m
//  community
//
//  Created by 蔡文练 on 2019/11/1.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "PhotoContainer.h"

@implementation PhotoContainer

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.itemSize = size;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.collectview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectview.backgroundColor = [UIColor whiteColor];
    self.collectview.delegate = self;
    self.collectview.dataSource = self;
    
    [self.collectview registerClass:[PhotoContainCell class] forCellWithReuseIdentifier:@"PhotoContainCell"];
    
    [self addSubview:self.collectview];
    [self.collectview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
}

-(void)refreshData:(NSArray *)dataArr{
    self.dataArr = dataArr;
    
    [self.collectview reloadData];
}
#pragma mark  设置CollectionView 组数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"PhotoContainCell";
    PhotoContainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell refreshImage:[NSString stringWithFormat:@"%@/%@",mainHost,self.dataArr[indexPath.item]]];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  self.itemSize;  //CGSizeMake(100,100 );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0,0,0,0);//（上、左、下、右）
//}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dianjiitemmmmmm");

    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = indexPath.item;
    browser.sourceImagesContainerView = self.collectview;
    browser.imageCount = self.dataArr.count;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",mainHost,self.dataArr[index]];
     NSURL *url = [NSURL URLWithString:imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    PhotoContainCell *cell = (PhotoContainCell *)[self.collectview cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UIImageView *imageView = cell.image;
    
    return imageView.image;
}

@end
