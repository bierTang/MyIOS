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

#import "LRSliderMenuView.h"

@interface CSLongVideoVC () <LRSliderMenuViewDelegate>

@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic, strong) MLMSegmentHead *segHead;

@property (nonatomic,strong)NSArray <VideoModel *> *titleArr;
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
     LRSliderMenuView * headview = [[LRSliderMenuView alloc]initWithFrame:CGRectMake(0, ItemSpaceHight, (int)(self.view.frame.size.width+riht), 50*K_SCALE) titleArray:titlearr titleHeight:50*K_SCALE normalColor:[UIColor colorWithHexString:@"161616"] selectedColor:[UIColor colorWithHexString:@"09c66a"] normalFont:[UIFont systemFontOfSize:16*K_SCALE] selectedFont:[UIFont systemFontOfSize:20*K_SCALE] normalFontSize:16*K_SCALE selectedFontSize:20*K_SCALE];
    headview.delegate = self;
    [self.view addSubview:headview];
//    [headview makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(0);
//        make.right.equalTo(riht);
//        make.top.equalTo(ItemSpaceHight+6);
//        make.height.equalTo(40*K_SCALE);
//    }];
    
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
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0,60,0,0) titles:titlearr headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutLeft];
    [self.view addSubview:self.segHead];
    
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
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0,ItemSpaceHight+50*K_SCALE,SCREEN_WIDTH, SCREEN_HEIGHT-TopSpaceHigh-50*K_SCALE) vcOrViews:self.viewArray];
    _segScroll.subtractHeight = 64;
    _segScroll.scrollEnabled = YES;
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    [self.view addSubview:self.segScroll];
        
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        NSLog(@"cccindex::");
    } selectBegin:^{
        
        NSLog(@"indexbbbegin");
    } selectEnd:^(NSInteger index) {
        NSLog(@"indexend::%ld",index);
        [headview setSelectIndex:index];
//        [headview titleBtnSelected:index];
        
    }];
    
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
