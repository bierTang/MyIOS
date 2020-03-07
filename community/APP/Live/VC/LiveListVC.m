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
    
        LiveListView *liveView = [[LiveListView alloc]init];
    liveView.showHeader = YES;
        [self.view addSubview:liveView];
        liveView.liveBlock = ^(LiveModel * _Nonnull model) {
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
    
        [liveView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-BottomSpaceHight);
        }];
        
        [[AppRequest sharedInstance]requestLiveListPingdao:self.model.pull Block:^(AppRequestState state, id  _Nonnull result) {
            NSLog(@"aa");
            if (state == AppRequestState_Success) {
                //遍历赋值
                NSArray<PingdaoModel *> *arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                
                NSMutableArray<LiveModel *> *mos = [NSMutableArray array];
                 for (PingdaoModel *str in arr) {
                    LiveModel *mo = [[LiveModel alloc]init];
                    if(str.cover.length > 1){
                       mo.imgUrl = str.cover;
                    }else{
                        mo.userName = str.headimage;
                    }
                     if(str.title.length > 1){
                         mo.userName = str.title;
                     }else{
                         mo.userName = str.name;
                     }
                    
                    mo.nums = str.Popularity;
                    mo.pull = str.video;
                    mo.city = str.city;
                     
                     [mos addObject:mo];
                 }
                
                [liveView reLoadCollectionView:mos];
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
