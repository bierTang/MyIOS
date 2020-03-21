//
//  LiveRecommandVC.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveListVC.h"
#import "LiveListView.h"
#import "LivePlayVC.h"

#import "YLLoopScrollView.h"
#import "YLCustomView.h"
#import "PingdaoModel.h"
@interface LiveListVC ()

//@property (nonatomic,strong)YLLoopScrollView *ylScrollview;
@property (nonatomic,strong)LiveListView *liveView;

@end

@implementation LiveListVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"直播";
    
    self.view.backgroundColor = [UIColor whiteColor];
//    __weak typeof(self) wself = self;
//    [[AppRequest sharedInstance]requestADSforType:@"7" Block:^(AppRequestState state, id  _Nonnull result) {
//        NSLog(@"轮播广告：：%@",result[@"code"]);
//        if (state == AppRequestState_Success) {
//            NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//            if (arr.count > 0) {
//                [self initScrollAds:[CSCaches shareInstance].lunboArr];
//            }
//        }
//    }];
    [self initUI];
}
-(void)initUI{
    
         self.liveView = [[LiveListView alloc]init];
   
        self.liveView.showHeader = YES;
 
        
        [self addChildViewController:self.liveView];
        [self.view addSubview:self.liveView.view];
        
        self.liveView.liveBlock = ^(LiveModel * _Nonnull model) {
            if ([HelpTools isMemberShip]) {
                LivePlayVC *liveVC = [[LivePlayVC alloc]init];
                liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
                
                liveVC.model = model;
                [self presentViewController:liveVC animated:YES completion:nil];
            }else{
                if (![UserTools isAgentVersion]) {
                    [HelpTools mustBeMemberShip:self];
                }else{
                    [[MYToast makeText:@"请先开通会员"]show];
                }
            }
        };
    

        [self.liveView.view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-BottomSpaceHight);
        }];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshData)];
       [header setTitle:@"刷新" forState:MJRefreshStateIdle];
       [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
       [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
       self.liveView.collectionView.mj_header = header;
    
    
        [self requestData];
}
-(void)freshData{
    [self requestData];
}
-(void)requestData{
    [[AppRequest sharedInstance]requestLiveListPingdao:self.model.pull Block:^(AppRequestState state, id  _Nonnull result) {
             NSLog(@"aa");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.liveView.collectionView.mj_header isRefreshing]) {
                [self.liveView.collectionView.mj_header endRefreshing];
            }
        });
        
             if (state == AppRequestState_Success) {
                 //遍历赋值
                 NSArray<PingdaoModel *> *arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                 //可能是大众频道的数据
                 if(!arr){
                     arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"zhubo"]];
                 }
                 NSMutableArray<LiveModel *> *mos = [NSMutableArray array];
                  for (PingdaoModel *str in arr) {
                     LiveModel *mo = [[LiveModel alloc]init];
                     if(str.cover.length > 1){
                        mo.imgUrl = str.cover;
                     }else if(str.headimage.length > 1){
                        mo.imgUrl = str.headimage;
                     }else{
                         mo.imgUrl = str.img;
                     }
                      if(str.title.length > 1){
                          mo.userName = str.title;
                      }else{
                          mo.userName = str.name;
                      }
                     
                     mo.nums = str.Popularity;
                      if (str.video.length > 1) {
                          mo.pull = str.video;
                      }else{
                          mo.pull = str.address;
                      }
                      if (mo.city.length > 1) {
                          mo.city = str.city;
                      }else{
                          mo.city = @"";
                      }
                     
                      
                      [mos addObject:mo];
                  }
                 
                 [self.liveView reLoadCollectionView:mos];
             }
         }];
}
////轮播图
//-(void)initScrollAds:(NSArray *)arr{
//
//    self.ylScrollview = [YLLoopScrollView loopScrollViewWithTimer:3 customView:^NSDictionary *{
//        return @{@"YLCustomView" : @"model"};
//    }];
//
//    self.ylScrollview.clickedBlock = ^(NSInteger index) {
//        YLCustomViewModel *mod = arr[index];
//        if (mod == nil) {
//            return ;
//        }
//        if (@available(iOS 10.0, *)) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link] options:@{} completionHandler:nil];
//        } else {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link]];
//        }
//
//    };
//    self.ylScrollview.dataSourceArr = arr;
//
//    self.ylScrollview.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];//RGBColor(245, 162, 0);
//    self.ylScrollview.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    self.ylScrollview.frame = CGRectMake(0,0,SCREEN_WIDTH,125*K_SCALE);
//    [self.view addSubview:self.ylScrollview];
//
//
//}

@end
