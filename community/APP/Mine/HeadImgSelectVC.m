//
//  HeadImgSelectVC.m
//  community
//
//  Created by MAC on 2020/1/17.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "HeadImgSelectVC.h"
#import "HeadImgSelectCell.h"

@interface HeadImgSelectVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation HeadImgSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HeadImgSelectCell class] forCellWithReuseIdentifier:@"HeadImgSelectCell"];
    }
    
    return _collectionView;
}


#pragma mark  设置CollectionView 组数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"HeadImgSelectCell";
    HeadImgSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    BOOL isSelect = NO;
//    [UserTools avatar].integerValue
    if (indexPath.item+1 == [UserTools avatar].integerValue) {
        isSelect = YES;
    }
    [cell refreshItem:indexPath.item+1 andIsSelect:isSelect];
    
    cell.headImgSelectBlock = ^(NSString * _Nonnull data) {
        [[CSCaches shareInstance]getUserModel:USERMODEL].avatar = [NSString stringWithFormat:@"%ld",indexPath.item+1];
        if (self.ImgSelectBlock) {
            self.ImgSelectBlock([NSString stringWithFormat:@"%ld",indexPath.item+1]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(60*K_SCALE,105*K_SCALE );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(16*K_SCALE,28*K_SCALE,1,28*K_SCALE);//（上、左、下、右）
}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 25*K_SCALE;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30;
}

@end
