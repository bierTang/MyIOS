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

@interface CSLiveVC ()

//@property (nonatomic,strong)YLLoopScrollView *ylScrollview;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic,strong) NSArray *viewArray;
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic, strong) NSString *recommNameStr;

@property (nonatomic, strong) UILabel *totalChannelLab;
@property (nonatomic, strong) LiveListView *liveView;

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
    
//    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0,60,0,0) titles:@[@"1",@"2"] headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutLeft];
//    [self.view addSubview:self.segHead];
    
//    LiveSegView *liveSeg = [[LiveSegView alloc]init];
//    liveSeg.backBlock = ^(UIButton * _Nonnull sender) {
//        //
//        wself.segHead.selectedIndex(sender.tag);
//    };
//    [self.view addSubview:liveSeg];
//    [liveSeg makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.height.equalTo(30);
//        make.top.equalTo(125*K_SCALE);
//    }];
    
    
    LiveListView *liveView = [[LiveListView alloc]init];
    liveView.liveBlock = ^(LiveModel * _Nonnull model) {
        if ([HelpTools isMemberShip]) {
            LivePlayVC *liveVC = [[LivePlayVC alloc]init];
            liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
            
            liveVC.model = model;
            [wself presentViewController:liveVC animated:YES completion:nil];
        }else{
            if (![UserTools isAgentVersion]) {
                [HelpTools mustBeMemberShip:self];
            }else{
                [[MYToast makeText:@"请先开通会员"]show];
            }
        }
        
    };
    self.liveView = liveView;
    LiveChannelVC *vc = [[LiveChannelVC alloc]init];
    
    self.viewArray = @[liveView,vc];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectZero vcOrViews:self.viewArray];
    _segScroll.scrollEnabled = YES;
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    [self.view addSubview:self.segScroll];
    
    
    SegHeadView *headview = [[SegHeadView alloc]initWithSegArray:@[@"推荐",@"频道"]];
        [self.view addSubview:headview];
        [headview makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(ItemSpaceHight+6);
            make.height.equalTo(40*K_SCALE);
        }];
        headview.segBlock = ^(NSInteger type) {
            wself.segHead.selectedIndex(type);
        };
        _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0,60,0,0) titles:@[@"1",@"2"] headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutLeft];
        [self.view addSubview:self.segHead];

        _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0,ItemSpaceHight+40*K_SCALE,SCREEN_WIDTH, SCREEN_HEIGHT-TopSpaceHigh-44) vcOrViews:self.viewArray];
        _segScroll.subtractHeight = 1;
        _segScroll.scrollEnabled = YES;
        _segScroll.loadAll = NO;
        _segScroll.showIndex = 0;
        [self.view addSubview:self.segScroll];
        
    
        [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
            NSLog(@"cccindex77::");
        } selectBegin:^{
            
            NSLog(@"indexbbbegin开始");
        } selectEnd:^(NSInteger index) {
            NSLog(@"indexend结束::%ld",index);
//            wself.segHead.selectedIndex(index);
            [headview titleBtnSelected:index];
            if (index == 1) {
                self.totalChannelLab.hidden = NO;
            }else{
                self.totalChannelLab.hidden = YES;
            }
    //        [liveSeg changeSeg:index];
            if (index==0 && wself.recommNameStr.length >0) {
                [[AppRequest sharedInstance]requestLiveList:wself.recommNameStr Block:^(AppRequestState state, id  _Nonnull result) {
                    NSLog(@"刷新请求");
                    if (result[@"list"]) {
                        [liveView reLoadCollectionView:[LiveModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
                    }
                }];
            }
        } selectScale:^(CGFloat scale) {
//                    NSLog(@"滑动中11::%lf",scale);

                  
                    [headview titleBtnSelectedYi:scale];
                    
                }];
    
    self.totalChannelLab = [UILabel labelWithTitle:@"" font:12*K_SCALE textColor:@"666666" textAlignment:NSTextAlignmentRight];
    self.totalChannelLab.hidden = YES;
    [self.view addSubview:self.totalChannelLab];
    [self.totalChannelLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headview.centerY).offset(-5);
        make.right.equalTo(-50*K_SCALE);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"service_nav"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headview.centerY).offset(-5);
        make.right.equalTo(-15);
    }];
    if ([UserTools isAgentVersion]) {
        addBtn.hidden = YES;
    }
    [[AppRequest sharedInstance]requestLiveAddressListBlock:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            [CSCaches shareInstance].liveDescString = result[@"data"][@"desc"];
            [CSCaches shareInstance].live_url = result[@"data"][@"live_url"];
            NSArray *arr = [result[@"data"][@"recommend"] componentsSeparatedByString:@"="];
            NSString *recomString = @"aiqinghai";
            if (arr[0]) {
                wself.recommNameStr = arr[0];
                recomString = arr[0];
            }
            [[AppRequest sharedInstance]requestLiveList:recomString Block:^(AppRequestState state, id  _Nonnull result) {
                NSLog(@"aa");
                if (state == AppRequestState_Success) {
                    [liveView reLoadCollectionView:[LiveModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
                }
            }];
        }
    }];
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshLiveChannel:) name:NOT_LIVETOTAL object:nil];
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
    
    if (self.recommNameStr.length > 0) {
        [[AppRequest sharedInstance]requestLiveList:self.recommNameStr Block:^(AppRequestState state, id  _Nonnull result) {
            NSLog(@"刷新请求");
            if (result[@"list"]) {
                [self.liveView reLoadCollectionView:[LiveModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
            }
        }];
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
