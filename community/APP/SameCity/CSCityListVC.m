//
//  CSCityListVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSCityListVC.h"

#import "CSSameCityItem.h"
#import "CSSameCityVC.h"
#import "CityListModel.h"

@interface CSCityListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray<CityListModel *> *dataArr;
@property (nonatomic,strong)NoDataView *nodataView;
@end

@implementation CSCityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    CSCityItemView *item = [[CSCityItemView alloc]init];
//    item.backgroundColor = [UIColor whiteColor];
//    item.frame = CGRectMake(100, 100, 165, 185);
//    [self.view addSubview:item];
    
//    [item makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(100);
//        make.left.equalTo(10);
//        make.width.equalTo(165);
//        make.height.equalTo(185);
//    }];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *param = nil;
    NSString *url = @"/index.php/index/city/all_city";
    if (self.isMyAttention) {
        param = @{@"user_id":[UserTools userID]};
        url = @"/index.php/index/post/user_attention_list";
    }
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]doRequestWithUrl:url Params:param Callback:^(BOOL isSuccess, id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            wself.dataArr = [CityListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [wself.collectionView reloadData];
        }
        
    } HttpMethod:AppRequestPost];
    
    if (self.isMyAttention) {
        self.nodataView = [[NoDataView alloc]initWithTitle:@"暂未添加关注"];
        [self.view addSubview:self.nodataView];
        [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(300);
            make.centerY.equalTo(self.view.centerY);
        }];
    }
   
    [self setUpNav];
}

-(void)setUpNav{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    
//    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 30, 44)];
//    [rightButtonView addSubview:mainAndSearchBtn];
//    [mainAndSearchBtn setImage:[UIImage imageNamed:@"nav_icon_search"] forState:UIControlStateNormal];
//    [mainAndSearchBtn addTarget:self action:@selector(mainAndSearchBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 35, 44)];
    [rightButtonView addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"service_nav"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    if ([UserTools isAgentVersion]) {
        addBtn.hidden = YES;
    }
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
-(void)addBtnEvent{
    NSLog(@"add");

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"在线客服";
    WebServeVC *vc = [[WebServeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[CSSameCityItem class] forCellWithReuseIdentifier:@"cellIdentify"];
    }
    
    return _collectionView;
}

#pragma mark  设置CollectionView 组数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellIdentify";
    CSSameCityItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.item % 2 == 0) {
        cell.backgroundColor = RGBColor(255, 255, 255);
    }else{
        cell.backgroundColor = RGBColor(250, 250, 250);
    }
    [cell refreshItem:self.dataArr[indexPath.item]];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = SCREEN_WIDTH / 3;
    return  CGSizeMake(width,60*K_SCALE );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,0,1,0);//（上、左、下、右）
}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dianjicell2");
    
//    if ([HelpTools isMemberShip]) {
        CSSameCityVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSSameCityVC"];//[[CSSameCityVC alloc]init];
        vc.cityModel = self.dataArr[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
//    }else if(![UserTools isLogin]){
//        [HelpTools jianquan:self];
//    }else{
//        NSString *str = @"请先开通会员";
//        if ([UserTools isAgentVersion]) {
//            str = @"请联系代理，购买卡密";
//        }
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的权限不足" message:str preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            if ([UserTools isAgentVersion]) {
//                self.tabBarController.selectedIndex = 3;
//            }else{
//                CSMallVC *vc = [[CSMallVC alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//        }];
//        [action1 setValue:RGBColor(9, 198, 106) forKey:@"_titleTextColor"];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"cancel");
//        }];
//        [action2 setValue:RGBColor(110, 110, 110) forKey:@"_titleTextColor"];
//        [alert addAction:action1];
//        [alert addAction:action2];
//
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end




