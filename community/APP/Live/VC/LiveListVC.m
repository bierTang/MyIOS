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
        
        [[AppRequest sharedInstance]requestLiveList:self.model.address Block:^(AppRequestState state, id  _Nonnull result) {
            NSLog(@"aa");
            if (state == AppRequestState_Success) {
                [liveView reLoadCollectionView:[LiveModel mj_objectArrayWithKeyValuesArray:result[@"zhubo"]]];
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
