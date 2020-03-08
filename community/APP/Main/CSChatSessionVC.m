//
//  CSChatSessionVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/4.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSChatSessionVC.h"
//#import "SessionImgCell.h"
#import "ManyPicCell.h"
#import "SessionGifCell.h"
#import "SessionTextCell.h"
#import "SessionVideoCell.h"
#import "SDPhotoBrowser.h"
#import "GroupInfoVC.h"
#import "ChatSendView.h"
#import "ShowGifVC.h"
#import "ADsView.h"
#import "YLLoopScrollView.h"
#import "YLCustomView.h"

///+
#import "VoicePlayCell.h"
#import "TextReadCell.h"
#import "TextReaderVC.h"
#import "AudioStreamer.h"

@interface CSChatSessionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray<SessionModel *> *dataArr;
@property (nonatomic,strong)NSMutableArray *tempArr;


@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,strong)ADsView *adView;
@property (nonatomic,strong)YLLoopScrollView *ylScrollview;

@property (nonatomic,strong)UIImageView *vipImage;

@property (nonatomic,strong)AudioStreamer *audioPlayer;

@property (nonatomic,copy)NSString *mp3String;

@property (nonatomic,strong)CSTimerManager *timerManager;

@property (nonatomic,strong)NSIndexPath *saveIndexPath;
@end

@implementation CSChatSessionVC

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    
    self.tempArr = [NSMutableArray new];
    self.currentPage = 1;

    ChatSendView *chatSend = [[ChatSendView alloc]init];
    [self.view addSubview:chatSend];
    [chatSend makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(49);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
    NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
    NSArray *Array = [jsonCode  mj_JSONObject];
    
    if (Array.count > 0) {
        self.tempArr = [SessionModel mj_objectArrayWithKeyValuesArray:Array.mutableCopy];
        self.dataArr = [[self.tempArr reverseObjectEnumerator]allObjects];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.backgroundColor = RGBColor(239, 239, 239);
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(chatSend.top);
    }];
    [self.tableView registerClass:[SessionVideoCell class] forCellReuseIdentifier:@"SessionVideoCell"];
    [self.tableView registerClass:[VoicePlayCell class] forCellReuseIdentifier:@"VoicePlayCell"];
//    [self.tableView registerClass:[ManyPicCell class] forCellReuseIdentifier:@"ManyPicCell"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    
//    FLAnimatedImageView *gif = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:gif];
//    
//    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.113/uploads/images/20191007/d9efdbde8af6041ce77725587f6820bc.gif"]]];
//    gif.animatedImage = animatedImage;
//    
    
    __weak typeof(self) wself = self;
//    self.chatroomId = @"8";
    if (Array.count > 0) {
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
    }
    [[AppRequest sharedInstance]requestSessionID:self.chatroomId current:[NSString stringWithFormat:@"%ld",self.currentPage] page:@"5" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"详情的第一次请求re::%@",result);
        if (state == AppRequestState_Success) {
            wself.totalPage = [result[@"data"][@"last_page"] integerValue];
            
            [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];
           
            
            if (Array.count == 0) {
                NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
                NSArray *Array = [jsonCode  mj_JSONObject];
                
                wself.tempArr = [SessionModel mj_objectArrayWithKeyValuesArray:Array.mutableCopy];
                
                wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];
                [wself.tableView reloadData];
                

                [MBProgressHUD hideHUDForView:wself.view animated:YES];
                if (wself.dataArr.count > 0) {
                    [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    

                }
            }
            
            
        }else{
            if (result[@"msg"]) {
                [[MYToast makeText:result[@"msg"]]show];
            }else{
                [[MYToast makeText:@"请求错误，稍后再试"]show];
            }
            
            [wself.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_header=header;
    [header setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
    
    self.adView = [[ADsView alloc]init];
    [self.view addSubview:self.adView];
    self.adView.hidden = YES;
    
    [self.adView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(65*K_SCALE);
        make.top.equalTo(20);
        make.right.equalTo(-16);
    }];
    
    
//    [[AppRequest sharedInstance]requestADSforType:@"3" Block:^(AppRequestState state, id  _Nonnull result) {
//        if (state == AppRequestState_Success) {
//            if ([result[@"data"][0][@"status"] intValue] == 1) {
//                wself.adView.hidden = NO;
//                [wself.adView setImageUrl:[NSString stringWithFormat:@"%@/%@",mainHost,result[@"data"][0][@"logo"]]];
//                wself.adView.linkUrl = result[@"data"][0][@"link"];
//            }
//        }
//
//
//    }];
    ////上面是单图广告，暂时隐藏，不显示，该成加入群的入口
    if ([CSCaches shareInstance].groupInfoModel.is_allow && [CSCaches shareInstance].groupInfoModel.group_allow==0) {
        self.vipImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"joinGroup"]];
        [self.view addSubview:self.vipImage];
        self.vipImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *joinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlejoinGroup)];
        [self.vipImage addGestureRecognizer:joinTap];
        
        [self.vipImage makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(20);
               make.right.equalTo(-16);
           }];
    }
    
    
    
    [[AppRequest sharedInstance]requestADSforType:@"4" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"轮播广告：：%@",result[@"code"]);
        if (state == AppRequestState_Success) {
            NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (arr.count > 0) {
                [wself initScrollAds:arr];
            }
        }
    }];
    
    self.timerManager = [CSTimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE updateInterval:1 repeatInterval:1 update:^{
        NSLog(@"定时器");
    }];
    
}

- (void)createStreamer:(NSString *)urlstring
{
    [self destroyStreamer];
    NSURL *originalURL = [NSURL URLWithString:urlstring];
    NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:originalURL];
    self.audioPlayer = [[AudioStreamer alloc] initWithURL:proxyURL];
}
- (void)destroyStreamer
{
    if (self.audioPlayer)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:self.audioPlayer];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

-(void)handlejoinGroup{
    [self useCoinPlay];
}


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
    self.ylScrollview.pageControl.hidden = YES;
//    self.ylScrollview.pageControl.currentPageIndicatorTintColor = RGBColor(245, 162, 0);
//    self.ylScrollview.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    CGFloat kk = K_SCALE;
    self.ylScrollview.frame = CGRectMake(SCREEN_WIDTH-166,150*kk+TopLiuHai,150,120);
    [self.view addSubview:self.ylScrollview];
    
    UIButton *closeAd=[UIButton buttonWithType:UIButtonTypeCustom];
    closeAd.frame = CGRectMake(SCREEN_WIDTH-16-13,150*kk+TopLiuHai-8,25,25);
    [closeAd setImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateNormal];
    [closeAd addTarget:self action:@selector(closeADsView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeAd];
    
    
}
-(void)closeADsView:(UIButton *)sender{
    [sender removeFromSuperview];
    [self.ylScrollview removeFromSuperview];
    self.ylScrollview = nil;
}

-(void)setUpNav{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    
    UIButton *moreBnt = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 30, 44)];
    [rightButtonView addSubview:moreBnt];
    [moreBnt setImage:[UIImage imageNamed:@"moreFun"] forState:UIControlStateNormal];
    [moreBnt addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
#pragma mark -- 群信息
-(void)showMore{
    NSLog(@"more");
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    GroupInfoVC *vc = [[GroupInfoVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)loadMoreData{
    
    __weak typeof(self) wself = self;
    if (self.currentPage < self.totalPage) {
        self.currentPage ++;
        [[AppRequest sharedInstance]requestSessionID:self.chatroomId current:[NSString stringWithFormat:@"%ld",self.currentPage] page:@"5" Block:^(AppRequestState state, id  _Nonnull result) {
            [wself.tableView.mj_header endRefreshing];
//            [MBProgressHUD hideHUDForView:wself.view animated:YES];
            if (state == AppRequestState_Success) {
//                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
//                [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];
//
//                NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
//                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:[jsonCode mj_JSONObject]];
                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                NSLog(@"caca::%ld",arr.count);
                NSInteger count = wself.dataArr.count;
                [wself.tempArr addObjectsFromArray:arr];
                wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];
                [wself.tableView reloadData];
                
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.dataArr.count-count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            
        }];
    }else{
        [self.tableView.mj_header removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//        return 25;
    return self.dataArr.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 160;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    if (self.dataArr[indexPath.row].ad_type == 1) {
        SessionVideoCell *cell = [[SessionVideoCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backBlock = ^(id  _Nonnull data) {
            
            if ([data intValue] == 200) {
//                self.dataArr[indexPath.row].hadLoaded = YES;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                NSLog(@"视频播放地址：：%@",wself.dataArr[indexPath.row].content);
                if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
                    CSVideoPlayVC *vc = [[CSVideoPlayVC alloc]init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    vc.playUrl = wself.dataArr[indexPath.row].content;//[NSString stringWithFormat:@"%@%@",mainHost,wself.dataArr[indexPath.row].content];
                    [wself presentViewController:vc animated:YES completion:nil];
                }else if([UserTools isLogin]){
                    NSLog(@"消耗金币");
                    [wself useCoinPlay];
                }else{
                    [HelpTools jianquan:self];
                }
            }

        };
        [cell refreshCell:self.dataArr[indexPath.row]];
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 3){
        SessionGifCell *cell = [[SessionGifCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backBlock = ^(id  _Nonnull data) {
            if ([data intValue]==200) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                ShowGifVC *vc = [[ShowGifVC alloc]init];
                vc.gifString = self.dataArr[indexPath.row].content;
                vc.gifid = self.dataArr[indexPath.row].idss;
                [wself.navigationController pushViewController:vc animated:YES];
            }
            
        };
        
        [cell refreshCell:self.dataArr[indexPath.row]];
        
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 2){
        SessionTextCell *cell = [[SessionTextCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCell:self.dataArr[indexPath.row]];
        
        return cell;
        
    }else if(self.dataArr[indexPath.row].ad_type == 0){
        ManyPicCell *cell = [[ManyPicCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backBlock = ^(id  _Nonnull data) {
//            [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        };
        [cell refreshCell:self.dataArr[indexPath.row]];
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 4){
        VoicePlayCell *cell = [[VoicePlayCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshVoice:self.dataArr[indexPath.row]];
        __weak typeof(self) wself = self;
        cell.voicePlayBlock = ^(id  _Nonnull data) {
            UIButton *btn = data;
            if (btn.isSelected) {
                
                if (wself.saveIndexPath == indexPath) {
                    [wself.audioPlayer pause];
                    NSLog(@"继续播放");
                }else{
                    wself.mp3String = wself.dataArr[indexPath.row].content;
                    [wself createStreamer:wself.mp3String];
                    NSLog(@"开始播放声音");
                    [wself.audioPlayer start];
                    if (wself.saveIndexPath) {
                        wself.dataArr[wself.saveIndexPath.row].mp3isPlaying = NO;
                         [wself.tableView reloadRowsAtIndexPaths:@[wself.saveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    wself.saveIndexPath = indexPath;
                }
            }else{
                wself.saveIndexPath = nil;
                [wself.audioPlayer pause];
            }
        };
        cell.sliderBlock = ^(NSInteger current) {
            [wself.audioPlayer seekToTime:current];
        };
        
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 5){
        TextReadCell *cell = [[TextReadCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLab.text = [self.dataArr[indexPath.row].name stringByAppendingString:@".txt"];
        
        return cell;
    }else{
        NSLog(@"错误类型");
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}
-(void)dealloc{
    NSLog(@"销毁了了了了了了了了");
}
-(void)controllerWillPopHandler{
    NSLog(@"处理返回事件");
    
    [self destroyStreamer];
    
    [self.timerManager pq_close];
}

-(void)useCoinPlay{
    if (![UserTools isLogin] || [UserTools userBlance]==0) {
        BOOL mem = [HelpTools jianquan:self];
        if (mem ==NO) {
            return;
        }
    }
    if (![HelpTools isMemberShip] && [UserTools userBlance] > 0){
        __weak typeof(self) wself = self;
        NSString *warnStr = [NSString stringWithFormat:@"您未开通本站会员，将消耗%ld金币进入该群",[CSCaches shareInstance].groupInfoModel.need_coin];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的权限不足" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [[AppRequest sharedInstance]requestEnterGroupByCoinID:[CSCaches shareInstance].groupInfoModel.idss Block:^(AppRequestState state, id  _Nonnull result) {
                    NSLog(@"aaa:::%@--%@",result,result[@"msg"]);
                    if (state == AppRequestState_Success) {
                        [[MYToast makeText:@"购买成功，加入该群"]show];
                        wself.vipImage.hidden = YES;
                        [CSCaches shareInstance].groupInfoModel.group_allow = YES;
                    }else if (result[@"msg"]){
                        [[MYToast makeText:result[@"msg"]]show];
                    }else{
                        [[MYToast makeText:@"购买失败"]show];
                    }
                }];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"cancel");
            }];
            [alert addAction:action1];
            [alert addAction:action2];
        
            [self presentViewController:alert animated:YES completion:nil];
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.dataArr[indexPath.row].ad_type == 0) {
//        self.imageUrl = [NSString stringWithFormat:@"%@%@",mainHost,self.dataArr[indexPath.row].content];
//        [self showBigImage];
//    }
    if (self.dataArr[indexPath.row].ad_type == 5) {
        NSLog(@"进入小说阅读界面");
        TextReaderVC *vc = [[TextReaderVC alloc]init];
        vc.txtId = self.dataArr[indexPath.row].story_id;
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = self.dataArr[indexPath.row].name;//@"小说名";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.dataArr[indexPath.row].ad_type == 4){
        NSLog(@"ddd:::%f--%f",self.audioPlayer.progress,self.audioPlayer.duration);
        
//        VoicePlayCell
        
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"停止滑动了：：%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 10) {
        [self loadMoreData];
    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"拖拽结束：：%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 50) {
        [self loadMoreData];
    }
   
}
//
//-(void)showBigImage{
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.fvc = self;
//    browser.currentImageIndex = 0;
//    browser.sourceImagesContainerView = self.view;
//    browser.imageCount = 1;
//    browser.delegate = self;
//    [browser show];
//}
//
//
//
//#pragma mark - SDPhotoBrowserDelegate
//
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    
//    NSURL *url = [NSURL URLWithString:self.imageUrl];
//    return url;
//}
//
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    UIImageView *imageView = self.view.subviews[index];
//    return imageView.image;
//}


@end
