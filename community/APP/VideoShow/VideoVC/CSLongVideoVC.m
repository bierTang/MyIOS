//
//  CSLongVideoVC.m
//  community
//
//  Created by MAC on 2020/1/5.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "CSLongVideoVC.h"
#import "SegHeadView.h"
#import "MLMSegmentManager.h"
#import "MLMSegmentScroll.h"
#import "RecommedVC.h"
#import "ClassifyVC.h"
#import "LRSliderMenuItem.h"
#import "LRSliderMenuView.h"

#import "微群社区-Swift.h"

@interface CSLongVideoVC () <LRSliderMenuViewDelegate>

@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic,strong)NSArray <VideoModel *> *titleArr;

@property (nonatomic, strong) LTLayout *layout;
@property (nonatomic, strong) LTPageView *pageView;
@end

@implementation CSLongVideoVC

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [RGBColor(224, 224, 224) colorWithAlphaComponent:0.8];
    
    [[AppRequest sharedInstance]requestVideoTitleBlock:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            self.titleArr = [VideoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self initSegTitle];
        }
    }];
    
}
NSInteger onCount = 0;

-(void)initSegTitle{
    NSMutableArray *titlearr = [NSMutableArray new];
    for (VideoModel *model in self.titleArr) {
        [titlearr addObject:model.title];
    }
   
    
    
    
    SegHeadView *headview111 = [[SegHeadView alloc]initWithSegArray:titlearr];
//    [self.view addSubview:headview];
    CGFloat riht = -50*K_SCALE;
    if ([UserTools isAgentVersion]) {
        riht = 0;
    }
//    [headview makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(riht);
//        make.top.equalTo(ItemSpaceHight+6);
//        make.height.equalTo(40*K_SCALE);
//    }];
//    headview.segBlock = ^(NSInteger type) {
//        [self changeType:type];
//    };
//     LRSliderMenuView * headview = [[LRSliderMenuView alloc]initWithFrame:CGRectMake(0, ItemSpaceHight, (int)(self.view.frame.size.width+riht), 50*K_SCALE) titleArray:titlearr titleHeight:50*K_SCALE normalColor:[UIColor colorWithHexString:@"161616"] selectedColor:[UIColor colorWithHexString:@"09c66a"] normalFont:[UIFont systemFontOfSize:16*K_SCALE] selectedFont:[UIFont systemFontOfSize:20*K_SCALE] normalFontSize:16*K_SCALE selectedFontSize:20*K_SCALE];
//    headview.delegate = self;
//    [self.view addSubview:headview];
//    [headview makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(riht);
//        make.top.equalTo(ItemSpaceHight+6);
//        make.height.equalTo(40*K_SCALE);
//    }];
    
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
     }else{
         self.addBtn.hidden = NO;
     }
    
//    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0,60,0,0) titles:titlearr headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutLeft];
//    [self.view addSubview:self.segHead];
    
    self.viewArray = [NSMutableArray new];
    for (int k=0; k<self.titleArr.count; k++) {
        RecommedVC *reVC = [[RecommedVC alloc]init];
        reVC.type = self.titleArr[k].idss;
        [self.viewArray addObject:reVC];
    }
    
    ClassifyVC *classVC = [[ClassifyVC alloc]init];
    classVC.type = self.titleArr[1].idss;
    for (VideoModel *vmodel in self.titleArr) {
        if (vmodel.is_diff.integerValue == 1) {
            NSInteger index0 = [self.titleArr indexOfObject:vmodel];
            NSLog(@"视频000：：：%ld",index0);
            [self.viewArray replaceObjectAtIndex:index0 withObject:classVC];
        }
    }
//    [self.viewArray replaceObjectAtIndex:1 withObject:classVC];
//    [self.viewArray insertObject:classVC atIndex:1];
    
    
        self.layout =  [[ LTLayout alloc]init];
        self.layout.bottomLineColor = [UIColor colorWithHexString:@"09c66a"];
        self.layout.titleColor = [UIColor colorWithHexString:@"161616"];
        self.layout.titleSelectColor = [UIColor colorWithHexString:@"09c66a"];
        self.layout.titleViewBgColor = [UIColor clearColor];
        self.layout.titleMargin = 20.0;
    
        if ([UserTools isAgentVersion]) {
            self.layout.allSliderWidth = SCREEN_WIDTH;
        }else{
            self.layout.allSliderWidth = SCREEN_WIDTH - 50;
        }
    
        
      
        self.pageView =  [[ LTPageView alloc]initWithFrame:CGRectMake(0, ItemSpaceHight, self.view.frame.size.width, self.view.frame.size.height-KTabBarHeight  - NoneTitleSpaceHight) currentViewController:self viewControllers:self.viewArray titles:titlearr layout:self.layout titleView:NULL];
    self.pageView.isClickScrollAnimation = YES;
    [self.view addSubview:self.pageView];

    self.pageView.didSelectIndexBlock = ^(LTPageView * _Nonnull l, NSInteger i) {
        if (onCount == 1) {
            ClassifyVC * cvc = self.viewArray[onCount];
            if (cvc.videoPlayer) {
                   [cvc.videoPlayer stop];
                   cvc.videoPlayer = nil;
               }
               [cvc.timerManager pq_close];
        }else{
             RecommedVC *rvc = self.viewArray[onCount];
            if (rvc.videoPlayer) {
                              [rvc.videoPlayer stop];
                              rvc.videoPlayer = nil;
                          }
                          [rvc.timerManager pq_close];
        }
        onCount = i;
    };
//    self.pageView.didSelectIndexBlock = {(_, index) in
//        print("pageView.didSelectIndexBlock", index)
//        let v = self.viewControllers[index] as! ViewController
//        v.status = self.titleStatusArray[index]
//    }
    
    
    
    
//    LTSimpleManager *simpleManager = [[ LTSimpleManager alloc]initWithFrame:CGRectMake(0, KNavHeight, self.view.frame.size.width, self.view.frame.size.height-KTabBarHeight) viewControllers:self.viewArray titles:titlearr currentViewController:self layout:layout titleView:NULL];
//    simpleManager.delegate = self;
    
//    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0,ItemSpaceHight+50*K_SCALE,SCREEN_WIDTH, SCREEN_HEIGHT-TopSpaceHigh-50*K_SCALE) vcOrViews:self.viewArray];
//    _segScroll.subtractHeight = 64;
//    _segScroll.scrollEnabled = YES;
//    _segScroll.loadAll = NO;
//    _segScroll.showIndex = 0;
//    [self.view addSubview:self.segScroll];
//
//    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
//        NSLog(@"cccindex::");
//    } selectBegin:^{
//
//        NSLog(@"indexbbbegin");
//    } selectEnd:^(NSInteger index) {
//        NSLog(@"indexend::%ld",index);
//        [headview setSelectIndex:index];
////        [headview titleBtnSelected:index];
//
//    } selectScale:^(CGFloat scale) {
//            NSLog(@"滑动中::%lf",scale);
//
//
//         [headview setSelectScale:scale];
//
//
//
////
////        double indexRatio = headview.contentScrollView.contentOffset.x / headview.contentScrollView.frame.size.width;
////        NSUInteger index = headview.contentScrollView.contentOffset.x / headview.contentScrollView.frame.size.width;
////         NSUInteger labelIndex = index;//滚动条加在smallScrollView上 要+1
//////            if (labelIndex +1 >= headview.contentScrollView.subviews.count || indexRatio < 0) {
//////                return;
//////            }
////            NSLog(@"\nindexRatio--- %f\nindex     --- %lu",indexRatio,(unsigned long)index);
////            LRSliderMenuItem *temlabel = headview.contentScrollView.subviews[labelIndex];
////            LRSliderMenuItem *temlabelNext = headview.contentScrollView.subviews[labelIndex +1];
////            if ((indexRatio-index) <= 0) {
////                temlabelNext = headview.contentScrollView.subviews[labelIndex -1];
////                temlabelNext.transform = CGAffineTransformMakeScale(200, 200);
////            }else{
////                temlabelNext = headview.contentScrollView.subviews[labelIndex +1];
////                temlabelNext.transform = CGAffineTransformMakeScale(100, 100);
////            }
////            CGPoint point = [headview.contentScrollView.panGestureRecognizer translationInView:self];
////            NSLog(@"point--- %@",NSStringFromCGPoint(point));
////
////
////            NSLog(@"当前页--- %d",index);
//    //        [headview titleBtnSelected:index];
//
//        }];
    
    
    
    
}

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([UserTools isAgentVersion]) {
        self.addBtn.hidden = YES;
        self.layout.allSliderWidth = SCREEN_WIDTH;
      }else{
        self.addBtn.hidden = NO;
        self.layout.allSliderWidth = SCREEN_WIDTH - 50;
      }
    self.pageView.titleWidth = self.layout.allSliderWidth;
}
- (void)sliderMenuView:(LRSliderMenuView *)sliderMenuView didClickMenuItemAtIndex:(NSInteger)index{
    self.segHead.selectedIndex(index);
    NSLog(@"华东和：：%ld",index);
}
-(void)changeType:(NSInteger)type{
    NSLog(@"cchange::%ld",type);
    self.segHead.selectedIndex(type);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOT_CHANGEVIEW object:nil];
}

@end
