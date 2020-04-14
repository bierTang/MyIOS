//
//  CSLiveVC.m
//  community
//
//  Created by MAC on 2020/2/12.
//  Copyright © 2020 cwl. All rights reserved.

#import "CSLiveVC.h"
//#import "YLLoopScrollView.h"
#import "YLCustomView.h"

#import "LiveSegView.h"

#import "MLMSegmentManager.h"
#import "MLMSegmentScroll.h"

#import "LiveListView.h"

#import "LiveChannelVC.h"

#import "LivePlayVC.h"
#import "SegHeadView.h"
#import "DaLiveChannelVC.h"
#import "LiveTitleModel.h"

#import "微群社区-Swift.h"

@interface CSLiveVC ()

//@property (nonatomic,strong)YLLoopScrollView *ylScrollview;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic, strong) NSString *recommNameStr;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *totalChannelLab;
@property (nonatomic, strong) LiveListView *liveView;
@property (nonatomic,strong)NSArray <LiveTitleModel *> *titleArr;
@property (nonatomic, strong) NSString *liveUrlStr;
@end

@implementation CSLiveVC

-(void)addBtnEvent{
    NSLog(@"add");
//    WebServeVC *vc = [[WebServeVC alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"在线客服";
    WebServeVC *vc = [[WebServeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [RGBColor(224, 224, 224) colorWithAlphaComponent:0.8];
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestADSforType:@"9" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"轮播广告：：%@",result[@"code"]);
        if (state == AppRequestState_Success) {
            NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (arr.count > 0) {
                [CSCaches shareInstance].lunboArr = arr;
//                [wself initScrollAds:arr];
            }
        }
    }];

    [[AppRequest sharedInstance]requestLiveTitle:^(AppRequestState state, id  _Nonnull result) {
              
                   if (state == AppRequestState_Success) {
                              self.titleArr = [LiveTitleModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                       [self initSegTitle];
                          }

               }];
    

    
    self.totalChannelLab = [UILabel labelWithTitle:@"" font:12*K_SCALE textColor:@"666666" textAlignment:NSTextAlignmentRight];
    self.totalChannelLab.hidden = YES;
    [self.view addSubview:self.totalChannelLab];
    [self.totalChannelLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KStatusBarHeight+20);
        make.right.equalTo(-50*K_SCALE);
    }];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.addBtn];
    [self.addBtn setImage:[UIImage imageNamed:@"service_nav"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KStatusBarHeight+15);
        make.right.equalTo(-15);
    }];
    if ([UserTools isAgentVersion]) {
        self.addBtn.hidden = YES;
    }

   [self requestData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshLiveChannel:) name:NOT_LIVETOTAL object:nil];
}
-(void)freshData{
    [self requestData];
}
-(void)requestData{
//        [[AppRequest sharedInstance]requestLiveAddressListBlock:^(AppRequestState state, id  _Nonnull result) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                       if ([self.liveView.collectionView.mj_header isRefreshing]) {
//                           [self.liveView.collectionView.mj_header endRefreshing];
//                       }
//                   });
//
//        if (state == AppRequestState_Success) {
//            [CSCaches shareInstance].liveDescString = result[@"data"][@"desc"];
//            [CSCaches shareInstance].live_url = result[@"data"][@"live_url"];
//            [CSCaches shareInstance].anchor_url = result[@"data"][@"anchor_url"];
//            NSArray *arr = [result[@"data"][@"recommend"] componentsSeparatedByString:@"="];
//            NSString *recomString = @"aiqinghai";
//            if (arr[0]) {
//                self.recommNameStr = arr[0];
//                recomString = arr[0];
//            }
//
//        }
//    }];
    if(self.liveUrlStr){
        [[AppRequest sharedInstance]requestLiveList:self.liveUrlStr Block:^(AppRequestState state, id  _Nonnull result) {
           
                        dispatch_async(dispatch_get_main_queue(), ^{
                                   if ([self.liveView.collectionView.mj_header isRefreshing]) {
                                       [self.liveView.collectionView.mj_header endRefreshing];
                                   }
                               });
            if (state == AppRequestState_Success) {
                 NSMutableArray *arr = [LiveModel mj_objectArrayWithKeyValuesArray:result[@"list"]];
                                                    
                  [self.liveView reLoadCollectionView:arr];
            }
        }];
    }
    
    
    
    
    }
-(void)initSegTitle{
//
//    LiveChannelVC *vc = [[LiveChannelVC alloc]init];
//           DaLiveChannelVC *vc1 = [[DaLiveChannelVC alloc]init];
           
           self.viewArray = [NSMutableArray new];
    LiveListView *liveView = [[LiveListView alloc]init];
         liveView.liveBlock = ^(LiveModel * _Nonnull model) {
             if ([HelpTools isMemberShip]) {
                 LivePlayVC *liveVC = [[LivePlayVC alloc]init];
                 liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
                 
                 liveVC.model = model;
                 [self presentViewController:liveVC animated:YES completion:nil];
             }else{
                 [HelpTools jianquan:self];
     //            if (![UserTools isAgentVersion]) {
     //                [HelpTools mustBeMemberShip:self];
     //            }else{
     //                [[MYToast makeText:@"请先开通会员"]show];
     //            }
             }
             
         };
         self.liveView = liveView;
    
    dispatch_async(dispatch_get_main_queue(), ^ {
         MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshData)];
              [header setTitle:@"刷新" forState:MJRefreshStateIdle];
              [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
              [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
              self.liveView.collectionView.mj_header = header;
    });
      
       
//           [self.viewArray addObject:self.liveView];
//           [self.viewArray addObject:vc];
//           [self.viewArray addObject:vc1];
    
     NSMutableArray *titleArray = [NSMutableArray new];
    for (LiveTitleModel *model in self.titleArr) {
//        if (model.url) {
            [titleArray addObject:model.title];
            if ([model.is_diff  isEqual: @"0"]) {
                LiveChannelVC *VC = [[LiveChannelVC alloc]init];
//                VC.name = model.url;
               [self.viewArray addObject:VC];
            }else{
                self.liveUrlStr = model.url;
                [self.viewArray addObject:self.liveView];
                
                
//                for (int i = 0; i < 1000; i++) {
//                    [self requestData];
////                    NSLog(@"%@",self.traverseArray[i]);
//
//                }
                
                [self requestData];
            }
//        }
        //如果第0个是频道数据需要加载一下
        if ([self.titleArr[0].is_diff  isEqual: @"0"]) {
            LiveChannelVC *vc = self.viewArray[0];
            [vc setPass: self.titleArr[0].need_pass];
            [vc setName: self.titleArr[0].url];
        }
        
         
     }
    
 
 
        LTLayout *layout =  [[ LTLayout alloc]init];
            layout.bottomLineColor = [UIColor colorWithHexString:@"09c66a"];
            layout.titleColor = [UIColor colorWithHexString:@"161616"];
            layout.titleSelectColor = [UIColor colorWithHexString:@"09c66a"];
            layout.titleViewBgColor = [UIColor clearColor];
            layout.titleMargin = 20.0;
          
         LTPageView *pageView =  [[ LTPageView alloc]initWithFrame:CGRectMake(0, ItemSpaceHight, self.view.frame.size.width, self.view.frame.size.height-KTabBarHeight  - NoneTitleSpaceHight) currentViewController:self viewControllers:self.viewArray titles:titleArray layout:layout titleView:NULL];
        pageView.isClickScrollAnimation = YES;
        pageView.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:pageView];
        
        pageView.didSelectIndexBlock = ^(LTPageView * v, NSInteger index) {
            if ([self.titleArr[index].is_diff  isEqual: @"0"]) {
                LiveChannelVC *vc = self.viewArray[index];
                [vc setPass: self.titleArr[index].need_pass];
                [vc setName: self.titleArr[index].url];
            }
//            if (index == 1) {
//                self.totalChannelLab.hidden = NO;
////                LiveChannelVC *vc = self.viewArray[1];
////                [vc setName:[CSCaches shareInstance].live_url];
//    //            NSLog(@"请求地址是：%@",vc.name);
//            }else if (index == 2) {
//                self.totalChannelLab.hidden = NO;
////                DaLiveChannelVC *vc = self.viewArray[2];
////                [vc setName:[CSCaches shareInstance].anchor_url];
//            //            NSLog(@"请求地址是：%@",vc.strUrl);
//                }else{
//                self.totalChannelLab.hidden = YES;
//            }
             self.totalChannelLab.hidden = YES;
            
        };
    
    
    
    
}


-(void)freshLiveChannel:(NSNotification *)not{
    NSLog(@"通知：%@",not.object);
    NSString *tt = not.object[@"total"];
    if (tt.integerValue > 0) {
        self.totalChannelLab.text = [NSString stringWithFormat:@"共有%@个频道",tt];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    [self requestData];
    
    if ([UserTools isAgentVersion]) {
            self.addBtn.hidden = YES;
       }else{
           self.addBtn.hidden = NO;
       }
    
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
