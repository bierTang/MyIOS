//
//  LiveListView.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveListView.h"
#import "LiveListHeaderView.h"

@implementation LiveListView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self initUI];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
-(void)initUI{
    
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"LiveListHeaderView"];
        [_collectionView registerClass:[LiveListItem class] forCellWithReuseIdentifier:@"LiveListItem"];
    }
    
    return _collectionView;
}

#pragma mark  设置CollectionView 组数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"LiveListItem";
    LiveListItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
   
    [cell refreshItem:self.dataArr[indexPath.item]];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake((SCREEN_WIDTH-16*3)/2.0,155*K_SCALE );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,16,1,16);//（上、左、下、右）
}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && self.showHeader) {//这是头部视图
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LiveListHeaderView" forIndexPath:indexPath];
        LiveListHeaderView *SectionHeadView = [[LiveListHeaderView alloc]init];
        SectionHeadView.frame =CGRectMake(0, 0,SCREEN_WIDTH,255*K_SCALE);
        SectionHeadView.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:SectionHeadView];
        return header;
    }else if([kind isEqualToString:UICollectionElementKindSectionHeader] && !self.showHeader){
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LiveListHeaderView" forIndexPath:indexPath];
        LiveListHeaderView *SectionHeadView = [[LiveListHeaderView alloc]init];
        SectionHeadView.frame =CGRectMake(0, 0,SCREEN_WIDTH,125*K_SCALE);
        SectionHeadView.clipsToBounds =YES;
        SectionHeadView.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:SectionHeadView];
        return header;
    } else{
        return nil;
    }
}
#pragma mark  定义每个UICollectionView头部尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.showHeader) {
        return CGSizeMake(SCREEN_WIDTH,255*K_SCALE);
    }else{
        return CGSizeMake(0,125*K_SCALE);
    }
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dianji进入直播:%@",[self.dataArr[indexPath.item] mj_JSONString]);
    if (self.liveBlock) {
        self.liveBlock(self.dataArr[indexPath.item]);
    }
//    UIResponder *responder=self;
//    UINavigationController *vv = nil;
//    while ((responder=[responder nextResponder])) {
//        if ([responder isKindOfClass:[UINavigationController class]]) {
//            vv = (UINavigationController *)responder;
//        }
//    }
    
}
-(void)reLoadCollectionView:(NSMutableArray *)arr{
    NSMutableArray *a = arr;

    for (int i = 0; i < arr.count; i++) {
        a = [self guolv:arr];
           
       }

    
    self.dataArr = a;
    [self.collectionView reloadData];
}

-(NSMutableArray *)guolv:(NSMutableArray *)a {
    NSMutableArray *arr = a;
    for (int i = 0; i < a.count; i++) {
     LiveModel *l = a[i];
     if(l.userName){
         if ([l.userName containsString:@"金花"] || [l.userName containsString:@"斗牛"]  || [l.userName containsString:@"娱乐"] || [l.userName containsString:@"赌场"]  || [l.userName containsString:@"牛牛"] || [l.userName containsString:@"娱乐城"] || [l.userName containsString:@"皇冠"] || [l.userName containsString:@"体育"] || [l.userName containsString:@"彩票"] || [l.userName containsString:@"游戏"] || [l.userName containsString:@"龙虎"] || [l.userName containsString:@"百家乐"] || [l.userName containsString:@"时时彩"] || [l.userName containsString:@"国际"] || [l.userName containsString:@"老虎机"] || [l.userName containsString:@"北京赛车"] || [l.userName containsString:@"PK10"] || [l.userName containsString:@"太阳城"] || [l.userName containsString:@"千炮"] || [l.userName containsString:@"六合彩"] || [l.userName containsString:@"博彩"] || [l.userName containsString:@"亚博"] || [l.userName containsString:@"赌球"] || [l.userName containsString:@"葡京"] || [l.userName containsString:@"威尼斯"] || [l.userName containsString:@"捕鱼"] || [l.userName containsString:@"娛樂城"] || [l.userName containsString:@"皇冠"] || [l.userName containsString:@"體育"] || [l.userName containsString:@"遊戲"] || [l.userName containsString:@"龍虎"] || [l.userName containsString:@"百家樂"] || [l.userName containsString:@"時時彩"] || [l.userName containsString:@"國際"] || [l.userName containsString:@"娛樂"] || [l.userName containsString:@"賭場"] || [l.userName containsString:@"自营"] || [l.userName containsString:@"平台"] || [l.userName containsString:@"提现"] || [l.userName containsString:@"筒子"]) {
             [arr removeObjectAtIndex:i];
             break;
              }
     }
        
    }
    return arr;
}


@end
