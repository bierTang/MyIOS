//
//  ClassifyVC.m
//  community
//
//  Created by MAC on 2020/1/6.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "ClassifyVC.h"
#import "MadeOfCell.h"
#import "ADsCell.h"
#import "YLLoopScrollView.h"
#import "YLCustomView.h"
#import "CSShareVC.h"
#import "IntroImgView.h"
@interface ClassifyVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray<VideoModel *> *dataArr;

@property (nonatomic,strong)IntroImgView *introImgview;
@property (nonatomic,strong)YLLoopScrollView *ylScrollview;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,copy)NSIndexPath *optionIndexPath;

@end

@implementation ClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor grayColor];
    
    NSLog(@"类型：：%@",self.type);
    //    [[AppRequest sharedInstance]requestADSforType:@"7" Block:^(AppRequestState state, id  _Nonnull result) {
    //        NSLog(@"轮播广告：：%@",result[@"code"]);
    //        if (state == AppRequestState_Success) {
    //            NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
    //            if (arr.count > 0) {
    //                [self initScrollAds:arr];
    //            }
    //        }
    //    }];
    [self initUI];
    
    [self requestData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOT_CHANGEVIEW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopVideoPlay) name:NOT_CHANGEVIEW object:nil];
}
-(void)stopVideoPlay{
    if (self.videoPlayer) {
        [self.videoPlayer stop];
        self.videoPlayer = nil;
    }
    [self.timerManager pq_close];
}
-(void)initUI{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[MadeOfCell class] forCellReuseIdentifier:@"MadeOfCell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableview.estimatedRowHeight = 666;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.tableview makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.top.bottom.equalTo(0);
        //        make.bottom.equalTo(BottomSpaceHight);
    }];
    
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
    self.tableview.mj_footer=footer;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableview.mj_header=header;
    [header setTitle:@"刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
}

//轮播图
-(void)initScrollAds:(NSArray *)arr{
    
    self.ylScrollview = [YLLoopScrollView loopScrollViewWithTimer:3 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];
    
    self.ylScrollview.clickedBlock = ^(NSInteger index) {
        YLCustomViewModel *mod = arr[index];
        if (mod == nil) {
            return ;
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link]];
        }
        
    };
    self.ylScrollview.dataSourceArr = arr;
    
    self.ylScrollview.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];//RGBColor(245, 162, 0);
    self.ylScrollview.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.ylScrollview.frame = CGRectMake(0,0,SCREEN_WIDTH,125*K_SCALE);
    [self.view addSubview:self.ylScrollview];
    
    //    [self.ylScrollview makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(0);
    //        make.top.equalTo(0);
    //        make.height.equalTo(80*K_SCALE);
    //    }];
}

-(void)requestData{
    [[AppRequest sharedInstance]requestVideoListType:self.type current:@"1" page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"国产::%@",result);
        if (state == AppRequestState_Success) {
            self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            [self.tableview reloadData];
            
            self.currentPage = 1;
            self.totalPage = [result[@"data"][@"last_page"] integerValue];
            //没有更多数据要重新设置，不然后面不会走上拉加载
            [self.tableview.mj_footer resetNoMoreData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.tableview.mj_header isRefreshing]) {
                [self.tableview.mj_header endRefreshing];
            }
        });
        
    }];
}
-(void)footerLoad{
    
    if (self.currentPage < self.totalPage) {
        self.currentPage ++;
        __weak typeof(self) wself = self;
        [[AppRequest sharedInstance]requestVideoListType:self.type current:[NSString stringWithFormat:@"%ld",self.currentPage] page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
            [wself.tableview.mj_footer endRefreshing];
            if (state == AppRequestState_Success) {
                [wself.dataArr addObjectsFromArray:[VideoModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]]];
                [wself.tableview reloadData];
                
            }
        }];
    }else{
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark -- tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    if (self.dataArr[indexPath.row].type == 1) {
        ADsCell *cell = [[ADsCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshData:self.dataArr[indexPath.row]];
        return cell;
    }else{
        MadeOfCell *cell = [[MadeOfCell alloc]cellInitWith:tableView Indexpath:indexPath];
        
        cell.videoBlock = ^(NSInteger type) {
            NSLog(@"视频播放：：%@",wself.dataArr[indexPath.row].video_url);
            if (type == 2) {
                //看缩略图
                self.introImgview.hidden = NO;
                [self.introImgview setIntroData:self.dataArr[indexPath.row]];
            }else if (type == 3) {
                    //充值
                    if (![UserTools isLogin]) {
                        [[MYToast makeText:@"请先登录"]show];
                        return ;
                    }
                    ///代理版本
                    if ([UserTools isAgentVersion]) {
                        KamiPayController *vc = [[ KamiPayController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                        //                       [self presentViewController:vc  animated:YES completion:nil];
                    }else{
                        //官方版本
                        //                       CSMallVC *vc = [[CSMallVC alloc]init];
                        KamiPayController *vc = [[ KamiPayController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }else if (type == 4) {
                    //分享
                    if (![UserTools isLogin]) {
                        [[MYToast makeText:@"请先登录"]show];
                        return ;
                    }
                    CSShareVC *vc = [[CSShareVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    
                    //        SJPlayModel *playModel =
                    //          [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:indexPath.row+100 atIndexPath:indexPath tableView:self.tableview];
                    ////        playModel.isPlayInTableView = YES;
                    //          SJVideoPlayerURLAsset *asset =
                    //          [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.dataArr[indexPath.row].video_url]
                    //                                           playModel:playModel];
                    //        wself.videoPlayer = [SJVideoPlayer player];
                    //////        _videoPlayer.lockedScreen = YES;
                    ////        _videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.dataArr[indexPath.row].file_url]];
                    //          // 2. 设置资源标题
                    ////          asset.title = @"DIY心情转盘 #手工##手工制作##卖包子喽##1块1个##卖完就撤#";
                    //          // 3. 默认情况下, 小屏时不显示标题, 全屏后才会显示, 这里设置一直显示标题
                    ////          asset.alwaysShowTitle = YES;
                    //        wself.videoPlayer.URLAsset = asset;
                    //        wself.videoPlayer.autoPlayWhenPlayStatusIsReadyToPlay = YES;
                    //          SJPlayModel *playModel =
                    //                    [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:indexPath.row+100 atIndexPath:indexPath tableView:self.tableview];
                    wself.optionIndexPath = indexPath;
                    wself.videoPlayer = [SJVideoPlayer player];
                    
                    wself.videoPlayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:wself.dataArr[indexPath.row].video_url]];
                    //        wself.videoPlayer.URLAsset.playModel = playModel;
                    //        wself.videoPlayer.clickedBackEvent = ^(SJVideoPlayer * _Nonnull player) {
                    //            NSLog(@"返回");
                    //        };
                    //
                    //是否竖屏时隐藏返回按钮
                    wself.videoPlayer.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
                    //是否隐藏底部进度条
                    wself.videoPlayer.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
                    [cell.videoBgView addSubview:wself.videoPlayer.view];
                    //        wself.videoPlayer.disabledGestures = SJPlayerDisabledGestures_Pan_V;
                    [wself.videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.offset(0);
                    }];
                    if (![HelpTools isMemberShip]) {
                        wself.timerManager=[CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:1 repeatInterval:1 update:^{
                            if (wself.videoPlayer.currentTime > 100) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //                        [wself.videoPlayer stopAndFadeOut];
                                    [wself.videoPlayer rotate:SJOrientation_Portrait animated:NO];
                                    [wself.videoPlayer stop];
                                    wself.videoPlayer = nil;
                                    cell.noVipView.hidden = NO;
                                    if ([UserTools isAgentVersion]) {
                                        cell.noVipView.view2.hidden = YES;
                                    }
                                    //                       [[MYToast makeText:@"试看结束，请先开通会员"]show];
                                });
                            }
                        }];
                    }
                    if ([UserTools isLogin]) {
                        [[AppRequest sharedInstance]requestMyseeingVideo:[UserTools userID] videoId:wself.dataArr[indexPath.row].idss Block:^(AppRequestState state, id  _Nonnull result) {
                            NSLog(@"观看了视频");
                        }];
                    }
                }
            // 设置资源
            //asset;
            
        };
        //    if (self.videoPlayer) {
        //        [self.videoPlayer stop];
        //        self.videoPlayer = nil;
        //    }
        
        cell.keepBlock = ^(UIButton * _Nonnull sender) {
            sender.selected = !sender.isSelected;
            NSLog(@"收藏");
            //
            [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/video_is_favorite" Params:@{@"user_id":[UserTools userID],@"post_id":self.dataArr[indexPath.row].idss} Callback:^(BOOL isSuccess, id result) {
                NSLog(@"加入收藏：：%@--%@",result,result[@"msg"]);
            } HttpMethod:AppRequestPost isAni:YES];
            if (sender.isSelected) {
                self.dataArr[indexPath.row].is_favorite = @"1";
            }else{
                self.dataArr[indexPath.row].is_favorite = @"0";
            }
            
            if (sender.isSelected) {
                self.dataArr[indexPath.row].favorite_num = [NSString stringWithFormat:@"%ld",self.dataArr[indexPath.row].favorite_num.integerValue+1];
            }else{
                self.dataArr[indexPath.row].favorite_num = [NSString stringWithFormat:@"%ld",self.dataArr[indexPath.row].favorite_num.integerValue-1];
            }
            cell.collectNumLab.text = self.dataArr[indexPath.row].favorite_num;
        };
        
        cell.laudBlock = ^(UIButton * _Nonnull sender) {
            sender.selected = !sender.isSelected;
            
            if (sender.isSelected) {
                self.dataArr[indexPath.row].is_favorite = @"1";
            }else{
                self.dataArr[indexPath.row].is_favorite = @"0";
            }
            
            if (sender.isSelected) {
                self.dataArr[indexPath.row].like_num = [NSString stringWithFormat:@"%ld",self.dataArr[indexPath.row].like_num.integerValue+1];
            }else{
                self.dataArr[indexPath.row].like_num = [NSString stringWithFormat:@"%ld",self.dataArr[indexPath.row].like_num.integerValue-1];
            }
            cell.praiseNumLab.text = self.dataArr[indexPath.row].like_num;
            
            [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/cate/video_is_like" Params:@{@"user_id":[UserTools userID],@"post_id":self.dataArr[indexPath.row].idss} Callback:^(BOOL isSuccess, id result) {
                NSLog(@"点赞：：%@",result);
            } HttpMethod:AppRequestPost isAni:YES];
        };
        
        
        NSLog(@"刷新：：%ld",indexPath.row);
        
        [cell refreshData:self.dataArr[indexPath.row]];
        return cell;
    }
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.optionIndexPath) {
        CGRect rect = [self.tableview rectForRowAtIndexPath:self.optionIndexPath];
        CGRect rectInSuperView = [self.tableview convertRect:rect toView:[self.tableview superview]];
        
        //滑动到了屏幕下方
        if ( rectInSuperView.origin.y > self.view.frame.size.height) {
            if (self.videoPlayer) {
                [self.videoPlayer stop];
                self.videoPlayer = nil;
            }
            
        }else if (rectInSuperView.origin.y + rectInSuperView.size.height < 0){
            //当前操作的cell高度  rectInSuperView.size.heigt
            //滑动到了屏幕上方
            if (self.videoPlayer) {
                [self.videoPlayer stop];
                self.videoPlayer = nil;
            }
        }else{
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.videoPlayer) {
        [self.videoPlayer stop];
        self.videoPlayer = nil;
    }
    [self.timerManager pq_close];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"选择了：：%@",self.dataArr[indexPath.row]);
    if (self.dataArr[indexPath.row].type == 0) {
        NSLog(@"视频：%@",self.dataArr[indexPath.row].video_url);
    }else if (self.dataArr[indexPath.row].type == 1){
        NSLog(@"广告");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.dataArr[indexPath.row].link] options:@{} completionHandler:nil];
    }
}

-(IntroImgView *)introImgview{
    if (!_introImgview) {
        _introImgview = [[IntroImgView alloc]init];
        _introImgview.frame = self.view.bounds;
        [self.view addSubview:_introImgview];
    }
    return _introImgview;
}
@end
