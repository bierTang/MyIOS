//
//  LiveChannelVC.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveChannelVC.h"
#import "LiveChannelCell.h"
#import "LiveListView.h"
#import "LivePlayVC.h"
#import "LiveListVC.h"
#import "LiveListHeaderView.h"
#import "ChannelModel.h"
#import "DaChannelModel.h"
@interface LiveChannelVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray<ChannelModel *> *dataArr;


@end

@implementation LiveChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//
//    UIView *view = [[UIView alloc]init];
//    [self.view addSubview:view];
//    view.backgroundColor = [UIColor whiteColor];
//    [view makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.equalTo(0);
//        make.bottom.equalTo(-44);
//    }];
    
    [self initUI];
    

     
}

-(void)initUI{
    
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshData)];
      [header setTitle:@"刷新" forState:MJRefreshStateIdle];
      [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
      [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
      self.collectionView.mj_header = header;
}

- (void)setName:(NSString *)name{
//    if (_name != name) {
        _name = name;
         [self requestData];
//    }
}

- (void)setPass:(NSString *)pass{
//    if (_name != name) {
        _pass = pass;
         
//    }
}




-(void)freshData{
//                    for (int i = 0; i < 2000; i++) {
//                        [self requestData];
//    //                    NSLog(@"%@",self.traverseArray[i]);
//
//                    }
    [self requestData];
}
-(void)requestData{
    NSLog(@"实际请求地址%@--是否加密%@",_name,_pass);
    [[AppRequest sharedInstance]requestLiveChannelList:_name pass:_pass Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"频道列表");
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.collectionView.mj_header endRefreshing];
                          
                       });
        if (state == AppRequestState_Success) {
            
            self.dataArr = [ChannelModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            //等于0可能是大众频道的数据，取pingtai
            if (self.dataArr.count == 0) {
                self.dataArr = [ChannelModel mj_objectArrayWithKeyValuesArray:result[@"pingtai"]];
            }
            
            
            [self.collectionView reloadData];
            if (self.dataArr.count > 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:NOT_LIVETOTAL object:@{@"total":[NSString stringWithFormat:@"%ld",self.dataArr.count]}];
            }
        }
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
        [_collectionView registerClass:[LiveChannelCell class] forCellWithReuseIdentifier:@"LiveChannelCell"];
        
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
    static NSString *identify = @"LiveChannelCell";
    LiveChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
   
    [cell refreshItem:self.dataArr[indexPath.item]];
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake((SCREEN_WIDTH-2)/3.0,(SCREEN_WIDTH-2)/3.0 );
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,1,1,1);//（上、左、下、右）
}
//#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LiveListHeaderView" forIndexPath:indexPath];
        LiveListHeaderView *SectionHeadView = [[LiveListHeaderView alloc]init];
        SectionHeadView.frame =CGRectMake(0, 0,SCREEN_WIDTH,125*K_SCALE);
        SectionHeadView.backgroundColor = [UIColor whiteColor];
        SectionHeadView.clipsToBounds=YES;
        [header addSubview:SectionHeadView];
        return header;
    }else{
        return nil;
    }
}

#pragma mark  定义每个UICollectionView头部尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([CSCaches shareInstance].lunboArr > 0) {
        return CGSizeMake(0,125*K_SCALE);
    }else{
        return CGSizeMake(0,0);
    }
    
    
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveModel *mo = [[LiveModel alloc]init];
    if (self.dataArr[indexPath.item].logo.length >1) {
        mo.imgUrl = self.dataArr[indexPath.item].logo;
    }else{
        mo.imgUrl = self.dataArr[indexPath.item].xinimg;
    }
    
    if (self.dataArr[indexPath.item].name.length >1) {
          mo.userName = self.dataArr[indexPath.item].name;
      }else{
           mo.userName = self.dataArr[indexPath.item].title;
      }
    
    if (self.dataArr[indexPath.item].quantity.length >1) {
         mo.nums = self.dataArr[indexPath.item].quantity;
      }else if (self.dataArr[indexPath.item].Number.length >1){
         mo.nums = self.dataArr[indexPath.item].Number;
      }else{
          mo.nums = @"0";
      }
    

    
    NSString *liveURL0 = self.name;
       
    
    
    if (self.dataArr[indexPath.item].source.length >1) {
             //替换某个字符
          NSString *url = [liveURL0 stringByReplacingOccurrencesOfString:@"/json" withString:[@"/" stringByAppendingString: self.dataArr[indexPath.item].source]];
          mo.pull = url;
        
      }else{
              //替换某个字符
          NSString *url = [liveURL0 stringByReplacingOccurrencesOfString:@"/json.txt" withString:[@"/" stringByAppendingString: self.dataArr[indexPath.item].address]];
          mo.pull = url;
         
      }
    mo.pass = _pass;
    
    
    [CSCaches shareInstance].currentLiveModel = mo;
    
    LiveListVC *vc = [[LiveListVC alloc]init];

    
    vc.model = mo;

    [self.navigationController pushViewController:vc animated:YES];
    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgView.backgroundColor = [UIColor clearColor];
//
//    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
//    [btn addTarget:self action:@selector(closeChannel:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:btn];
//    
//    UIView *view0 = [[UIView alloc]init];
//    view0.backgroundColor = [UIColor whiteColor];
//    [bgView addSubview:view0];
//    [view0 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.equalTo(TopLiuHai+KNavHeight);
//        make.height.equalTo(155*K_SCALE);
//    }];
//    
//    UIView *greenView = [[UIView alloc]init];
////    greenView.backgroundColor = RGBColor(86, 211, 95);
//    [bgView addSubview:greenView];
//    UIImageView *greenImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"greenShadow"]];
//    [greenView addSubview:greenImg];
//    [greenImg makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.top.bottom.equalTo(0);
//    }];
//    
//    [greenView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(TopLiuHai+KNavHeight);
//        make.left.right.equalTo(0);
//        make.height.equalTo(98*K_SCALE);
//    }];
//    
//    UIButton *closeChannel = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeChannel setImage:[UIImage imageNamed:@"closeLive"] forState:UIControlStateNormal];
//    [closeChannel addTarget:self action:@selector(closeChannel:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:closeChannel];
//    [closeChannel makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-5);
//        make.top.equalTo(greenView.top).offset(10);
//    }];
//    
//    
//    UILabel *titleLabe = [UILabel labelWithTitle:self.dataArr[indexPath.item].title font:20*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
//    titleLabe.font = [UIFont boldSystemFontOfSize:20*K_SCALE];
//    [greenView addSubview:titleLabe];
//    
//    [titleLabe makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(15);
//        make.top.equalTo(0);
//        make.height.equalTo(50*K_SCALE);
//    }];
//    
//    UIView *introBgView = [[UIView alloc]init];
//    introBgView.backgroundColor = [UIColor whiteColor];
//    introBgView.layer.cornerRadius = 8;
////    introBgView.clipsToBounds = YES;
//    [bgView addSubview:introBgView];
//    
//    [introBgView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(16);
//        make.right.equalTo(-16);
//        make.height.equalTo(55*K_SCALE);
//        make.top.equalTo(titleLabe.bottom);
//    }];
//    
//        introBgView.layer.shadowOffset = CGSizeMake(2, 2);
//        introBgView.layer.shadowColor = [UIColor colorWithHexString:@"efefef"].CGColor;
//        introBgView.layer.shadowRadius = 3;
//        introBgView.layer.shadowOpacity = 1;
//    
//    
//    UIImageView *img0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base_3"]];
//    [introBgView addSubview:img0];
//    img0.layer.cornerRadius = 18*K_SCALE;
//    img0.clipsToBounds = YES;
//    [img0 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(10);
//        make.centerY.equalTo(introBgView.centerY);
//        make.height.width.equalTo(36*K_SCALE);
//    }];
//    NSString *strImg = self.dataArr[indexPath.item].img;
//    if (strImg.length < 5) {
//        strImg = self.dataArr[indexPath.item].xinimg;
//    }
//    [img0 sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"headImg_base_3"]];
//    
//    UILabel *lab0 = [UILabel labelWithTitle:@"平台介绍" font:15*K_SCALE textColor:@"000000" textAlignment:NSTextAlignmentLeft];
//    lab0.font = [UIFont boldSystemFontOfSize:16*K_SCALE];
//    [introBgView addSubview:lab0];
//    [lab0 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(img0.right).offset(6);
//        make.top.equalTo(0);
//        make.height.equalTo(30*K_SCALE);
//    }];
//    
//    NSString *desc = [CSCaches shareInstance].liveDescString;
//    if (desc.length < 1) {
//        desc = @"暂无介绍";
//    }
//    UILabel *labintro = [UILabel labelWithTitle:desc font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
//    [introBgView addSubview:labintro];
//    [labintro makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(img0.right).offset(6);
//        make.bottom.equalTo(introBgView.bottom);
//        make.height.equalTo(30*K_SCALE);
//    }];
//    
//    
//    
//    
//    LiveListView *liveView = [[LiveListView alloc]init];
//    [bgView addSubview:liveView];
//    liveView.liveBlock = ^(LiveModel * _Nonnull model) {
//        if ([HelpTools isMemberShip]) {
//            LivePlayVC *liveVC = [[LivePlayVC alloc]init];
//            liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            
//            liveVC.model = model;
//            [self presentViewController:liveVC animated:YES completion:nil];
//        }else{
//            [[MYToast makeText:@"请先开通会员"]show];
//        }
//    };
//    
//    [liveView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introBgView.bottom).offset(6);
//        make.left.right.equalTo(0);
//        make.bottom.equalTo(-BottomSpaceHight-44);
//    }];
//    
//    [[AppRequest sharedInstance]requestLiveList:self.dataArr[indexPath.item].address Block:^(AppRequestState state, id  _Nonnull result) {
//        NSLog(@"aa");
//        if (state == AppRequestState_Success) {
//            [liveView reLoadCollectionView:[LiveModel mj_objectArrayWithKeyValuesArray:result[@"zhubo"]]];
//        }
//    }];
    
}
-(void)closeChannel:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
}

@end
