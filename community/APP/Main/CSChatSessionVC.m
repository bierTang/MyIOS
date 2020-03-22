//
//  CSChatSessionVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/4.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSChatSessionVC.h"
//#import "SessionImgCell.h"
#import "AdCell.h"
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


#import "YBImageBrowser.h"
#import "YBIBVideoData.h"

#if __has_include("YBIBDefaultWebImageMediator.h")
#import "YBIBDefaultWebImageMediator.h"
#endif
#import "BGFMDB.h"
//log输出解决 xcode8 log 显示不全
#ifdef DEBUG
#define QMLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define QMLog(format, ...)
#endif





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

@property (nonatomic,strong)AVPlayer *aplayer;

@property (nonatomic,copy)NSString *mp3String;

@property (nonatomic,strong)CSTimerManager *timerManager;

@property (nonatomic,strong)NSIndexPath *saveIndexPath;

//存图片视频的集合
@property (nonatomic,strong)NSMutableArray *datas;

//存图片集合
@property (nonatomic,strong)NSMutableArray *imageArr;
//直到底部的按钮
@property (nonatomic,strong)UIButton *bottomBtn;
//底部的数量
@property (nonatomic,strong)UILabel *countLabel;

//重写的音频播放
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) id timeObserver;

/*
 * 是否处于seek阶段/seek中间会存在一个不同步问题
 * 所以在seek中间不处理 addPeriodicTimeObserverForInterval
 */
@property (nonatomic, assign) BOOL isSeeking;
//是否拖拽中
@property (nonatomic, assign) BOOL isDragging;
////播放状态
@property (nonatomic, assign) VedioStatus playerStatus;
//总播放时长
@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) NSInteger maximumValue;
//进度条的值
@property (nonatomic, assign) NSInteger dragValue;


@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat trackValue;
@property (nonatomic,assign)NSString* mp3Add;

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
    bg_setDebug(YES);//打开调试模式,打印输出调试信息.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    
    self.tempArr = [NSMutableArray new];
    self.currentPage = 1;
    self.datas = [NSMutableArray array];
    //添加图片数据
    self.imageArr = [NSMutableArray array];
    ChatSendView *chatSend = [[ChatSendView alloc]init];
    [self.view addSubview:chatSend];
    [chatSend makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(49);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
//    NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
//    NSArray *Array = [jsonCode  mj_JSONObject];
    
    /**
        查询标识名为testA的数组全部元素.
        */
    /**
    同步查询所有数据.
    */
    NSArray* Array = [SessionModel bg_findAll:[@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
   
        NSLog(@"结果 = %@",Array);
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSInteger looki = [defaults integerForKey:[@"Look" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];//根据键值取出name

    if (Array.count > 0) {
//        self.tempArr = [SessionModel mj_objectArrayWithKeyValuesArray:Array.mutableCopy];

        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        // 排序结果
        NSMutableArray *tArr = [NSMutableArray new];
       
        [tArr addObjectsFromArray:[Array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
        self.dataArr = tArr;
        
        
        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
         NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
       
         [self.tempArr addObjectsFromArray:[Array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]]];
        
        
//        self.dataArr = [[Array reverseObjectEnumerator]allObjects];
        NSLog(@"第一条 = %ld",(long)self.dataArr[0].id);
        NSLog(@"第后条 = %ld",(long)self.dataArr[self.dataArr.count-1].id);
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
 
    self.tableView.backgroundColor = RGBColor(239, 239, 239);
    [self.view addSubview:self.tableView];
    //去掉横线
       self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(chatSend.top);
    }];
    [self.tableView registerClass:[SessionVideoCell class] forCellReuseIdentifier:@"SessionVideoCell"];
//    [self.tableView registerClass:[VoicePlayCell class] forCellReuseIdentifier:@"VoicePlayCell"];
    [self.tableView registerClass:[ManyPicCell class] forCellReuseIdentifier:@"ManyPicCell"];

    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.bottomBtn setImage:[UIImage imageNamed:@"chat_bottom"] forState:UIControlStateNormal];
//     [self.bottomBtn setImage:[UIImage imageNamed:@"pause_mp3icon"] forState:UIControlStateSelected];

     [self.bottomBtn addTarget:self action:@selector(toBottom:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.bottomBtn];
    self.bottomBtn.hidden = YES;
    [self.bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(chatSend.top).offset(-15);
    }];
    self.countLabel = [UILabel labelWithTitle:@"0" font:13*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:self.countLabel];
    [self.countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBtn.top).offset(8);
        make.width.height.equalTo(28);
        make.centerX.equalTo(self.bottomBtn);
    }];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    self.countLabel.layer.cornerRadius = 14;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.hidden = YES;
    

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
        if (looki){
            if (looki >= self.dataArr.count) {
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:looki inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }else{
            if (looki == 0) {
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:looki inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }else{
                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
        }
        
        [wself.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        
   
        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[self.dataArr.count-1].id] current:@"100" page:@"2" Block:^(AppRequestState state, id  _Nonnull result) {
                    if (state == AppRequestState_Success) {
                        NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                        NSLog(@"caca::%ld",arr.count);
                        if (arr.count > 0){
                            for (SessionModel *i in arr){
                                i.bg_tableName = [@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ];
                                                   }
                                /**
                                    同步 存储或更新 数组元素.
                                当"唯一约束"或"主键"存在时，此接口会更,没有则存储新数据.
                                    提示：“唯一约束”优先级高于"主键".
                                */
                           [SessionModel bg_saveOrUpdateArray:arr];
//                              [arr bg_saveArrayWithName:[@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
                            NSInteger count = arr.count;
                            // 插入最前方
                               NSMutableIndexSet  *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)];
                            arr = [[arr reverseObjectEnumerator]allObjects];
                            [wself.tempArr insertObjects:arr atIndexes:indexes];
                            wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];

                            [wself.tableView reloadData];
//                            [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.dataArr.count-count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

                            self.bottomBtn.hidden = NO;
                            self.countLabel.hidden = NO;
                            if(arr.count > 99){
                                self.countLabel.text = @"99+";
                            }else{
                                self.countLabel.text = [NSString stringWithFormat:@"%ld", arr.count];
                            }
                            
                        }


                    }


                }];
        
        
    }else{
         [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", NSIntegerMax] current:@"10" page:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
                QMLog(@"详情的第一次请求re::%@",result[@"data"]);
                if (state == AppRequestState_Success) {
                    wself.totalPage = [result[@"data"][@"last_page"] integerValue];
                    
        //            [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];
                   
                    
                    if (Array.count == 0) {
        //                NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
        //                NSArray *Array = [jsonCode  mj_JSONObject];
                        
                        
                        
                        wself.tempArr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                        
                        
                        for (SessionModel *i in wself.tempArr){
                            i.bg_tableName = [@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ];
                        }
                        /**
                        同步 存储或更新 数组元素.
                        当"唯一约束"或"主键"存在时，此接口会更新旧数据,没有则存储新数据.
                        提示：“唯一约束”优先级高于"主键".
                        */
                        [SessionModel bg_saveOrUpdateArray:wself.tempArr];
                        
//                        [wself.tempArr bg_saveArrayWithName:[@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
                        
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
    }
    
    
    
   
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_header=header;
    [header setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
    
    
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer=footer;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    

    
    
    
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
        //暂时隐藏vip图标
        self.vipImage.hidden = true;
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

//直达底部按钮
-(void)toBottom:(UIButton *)sender{
    self.bottomBtn.hidden = YES;
    self.countLabel.hidden = YES;
   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


- (void)createStreamer:(NSString *)urlstring
{
    [self destroyStreamer];
    NSURL *originalURL = [NSURL URLWithString:urlstring];
    NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:originalURL];
    self.audioPlayer = [[AudioStreamer alloc] initWithURL:proxyURL];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:urlstring] options:nil];
    AVPlayerItem *songitem = [[AVPlayerItem alloc] initWithAsset:asset];
    self.aplayer = [[AVPlayer alloc] initWithPlayerItem:songitem];
    
    
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
//    [self useCoinPlay];
     [HelpTools jianquan:self];
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

//上拉的时候要加载的
-(void)loadMore{
    
    __weak typeof(self) wself = self;

        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[self.dataArr.count-1].id] current:@"40" page:@"2" Block:^(AppRequestState state, id  _Nonnull result) {
            [wself.tableView.mj_footer endRefreshing];
//            [MBProgressHUD hideHUDForView:wself.view animated:YES];
            if (state == AppRequestState_Success) {

                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                NSLog(@"caca::%ld",arr.count);
                if (arr.count > 0){
                    for (SessionModel *i in arr){
                                               i.bg_tableName = [@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ];
                                           }
                                           /**
                                           同步 存储或更新 数组元素.
                                           当"唯一约束"或"主键"存在时，此接口会更新旧数据,没有则存储新数据.
                                           提示：“唯一约束”优先级高于"主键".
                                           */
                                           [SessionModel bg_saveOrUpdateArray:arr];
                    
                    // 插入最前方
                                      NSMutableIndexSet  *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)];
                                   [wself.tempArr insertObjects:arr atIndexes:indexes];
                                   wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];
                                   
                                   [wself.tableView reloadData];

                }else{
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
              
//                NSInteger count = wself.dataArr.count;
               
//                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.dataArr.count-count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
            
        }];

    
}

//下拉加载的
-(void)loadMoreData{
    
    __weak typeof(self) wself = self;
   
        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[0].id] current:@"40" page:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
            [wself.tableView.mj_header endRefreshing];
            QMLog(@"传的id:%ld",(long)self.dataArr[0].id);
             QMLog(@"下拉更新:%@",result);
//            [MBProgressHUD hideHUDForView:wself.view animated:YES];
            if (state == AppRequestState_Success) {
 
                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                NSLog(@"caca::%ld",arr.count);
                if (arr.count > 0){
                    for (SessionModel *i in arr){
                                               i.bg_tableName = [@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ];
                                           }
                                           /**
                                           同步 存储或更新 数组元素.
                                           当"唯一约束"或"主键"存在时，此接口会更新旧数据,没有则存储新数据.
                                           提示：“唯一约束”优先级高于"主键".
                                           */
                                           [SessionModel bg_saveOrUpdateArray:arr];
//                    [arr bg_saveArrayWithName:[@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
                    

                NSInteger count = arr.count;
              [wself.tempArr addObjectsFromArray:arr];
//                    // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
//                          NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
//                          // 排序结果
//                          wself.dataArr = [wself.tempArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    
                    
                wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];
                                    
                    //           [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];

                                    
                   [wself.tableView reloadData];
                   [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    
                    
                    
                }
                
            }
            
            
        }];

    
}
//下拉加载的
//-(void)loadMoreData{
//
//    __weak typeof(self) wself = self;
//    if (self.currentPage < self.totalPage) {
//        self.currentPage ++;
//        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[self.dataArr.count-1].id] current:@"10" page:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
//            [wself.tableView.mj_header endRefreshing];
////            [MBProgressHUD hideHUDForView:wself.view animated:YES];
//            if (state == AppRequestState_Success) {
//
//
//
////                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
////                [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];
////
////                NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_Main Identify:[CSCaches shareInstance].groupInfoModel.idss versionCode:@"1"];
////                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:[jsonCode mj_JSONObject]];
//                NSArray *arr = [SessionModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
//                NSLog(@"caca::%ld",arr.count);
//                [arr bg_saveArrayWithName:[@"Chat" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
//                NSInteger count = wself.dataArr.count;
//                [wself.tempArr addObjectsFromArray:arr];
//                wself.dataArr = [[wself.tempArr reverseObjectEnumerator]allObjects];
//
////           [CSDataBase insertCacheDataByIdentify:[CSCaches shareInstance].groupInfoModel.idss CacheType:DB_Main versionCode:@"1" data:[result[@"data"][@"lists"] mj_JSONString]];
//
//
//
//                [wself.tableView reloadData];
//
//
//
//                [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:wself.dataArr.count-count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//            }
//
//
//        }];
//    }else{
//        [self.tableView.mj_header removeFromSuperview];
//        [self.tableView.mj_header endRefreshing];
//    }
//
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//        return 25;
    return self.dataArr.count;
}



//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 160;
//}

//tableview 加载完成可以调用的方法--因为tableview的cell高度不定，所以在加载完成以后重新计算高度
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
//    if (indexPath.row == self.dataArr.count - 1){
//        //刷新完成
//                           [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self getNowTopSectionView];
}
 

 NSInteger nowSection = -1;
NSInteger topSection = -1;
// 获取tableView最上面悬停的SectionHeaderView
- (void)getNowTopSectionView {
    NSArray <UITableViewCell *> *cellArray = [self.tableView visibleCells];
//    NSInteger nowSection = -1;
    if (cellArray) {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        nowSection = indexPath.row;
    }
    
    //大于20个就显示
       if (self.dataArr.count > 20 && nowSection <= self.dataArr.count - 20) {
           self.bottomBtn.hidden = NO;
       }
    

   
    
    //滑动到少于10个时就隐藏掉
    if (nowSection >= self.dataArr.count - 10) {
        self.bottomBtn.hidden = YES;
        self.countLabel.hidden = YES;
                                   
    }else{
        if (nowSection > topSection) {
//            NSLog(@"往下滑动:%ld",nowSection);
//            NSLog(@"往下滑动1:%ld",topSection);
             if (!self.countLabel.isHidden) {
                 //小于99个才开始显示
                 if (nowSection >= self.dataArr.count - 99) {
                     self.countLabel.text = [NSString stringWithFormat:@"%ld", self.dataArr.count - nowSection];
                 }
                   
               }
        }
        
        
    }
    topSection = nowSection;
//    NSLog(@"当前滑动到:%ld",nowSection);
//    NSLog(@"一共有:%ld",self.dataArr.count);
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"消失啦即将%s", __FUNCTION__);
    [super viewWillDisappear:animated];
}

//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"消失啦%s", __FUNCTION__);
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setInteger:nowSection forKey:[@"Look" stringByAppendingString: [CSCaches shareInstance].groupInfoModel.idss ]];
    
 [self destroyPlayer];
    
    
    [super viewDidDisappear:animated];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    if (self.dataArr[indexPath.row].ad_type == 1) {
;
        SessionVideoCell *cell = [[SessionVideoCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.backBlock = ^(id  _Nonnull data) {
            
            if ([data intValue] == 99999) {
//                self.dataArr[indexPath.row].hadLoaded = YES;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                NSLog(@"视频播放地址：：%@",wself.dataArr[indexPath.row].video_url);
//                if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
                     if ([HelpTools isMemberShip] ) {
//                    CSVideoPlayVC *vc = [[CSVideoPlayVC alloc]init];
//                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//                    vc.playUrl = wself.dataArr[indexPath.row].content;//[NSString stringWithFormat:@"%@%@",mainHost,wself.dataArr[indexPath.row].content];
//                    [wself presentViewController:vc animated:YES completion:nil];
                    
                      //添加视频数据
                    NSMutableArray *datass = [NSMutableArray array];
                    NSMutableArray *urlArr = [NSMutableArray array];
                                             [self.dataArr enumerateObjectsUsingBlock:^(SessionModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //                                               if (obj.ad_type == 0){
                    //                                                   // 网络图片
                    //
                    //                                                   for(NSString *i in obj.images_array ){
                    //                                                       YBIBImageData *data = [YBIBImageData new];
                    //                                                      data.imageURL = i;
                    //
                    //                                                       //                   data.projectiveView = self;
                    //                                                                          [self.datas addObject:data];
                    //                                                   }
                    //
                    //                               }else
                                                       if(obj.ad_type == 1){
                                                           //              网络视频
                                                YBIBVideoData *data = [YBIBVideoData new];
                                                data.videoURL = [NSURL URLWithString:obj.video_url];
//                                                           data.videoURL = [NSURL URLWithString:@"http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4"];
                                                  data.thumbURL = [NSURL URLWithString:obj.images];
                                                data.projectiveView = [self videoAtIndex:idx];
//                                                           data.autoPlayCount = 1;
                                                           data.allowSaveToPhotoAlbum = NO;
                                                           [urlArr addObject:obj.video_url];
                                                [datass addObject:data];
                                                                }
                                                               }];
                 
                    
                     NSLog(@"资源有%lu",(unsigned long)self.datas.count);
                    NSLog(@"点击的是%lu",(unsigned long)indexPath.row);
                        NSLog(@"条目有%lu",(unsigned long)self.dataArr.count);
                    NSLog(@"tag是%lu",(unsigned long)[data intValue]);
                    
                    
                    //是否包含
                    if ([urlArr containsObject:self.dataArr[indexPath.row].video_url]) {
                        
                        NSInteger index = [urlArr indexOfObject:self.dataArr[indexPath.row].video_url];
                        NSLog(@"-1---%ld---",index);
                        //单独把这个视频自动播放一次
                        YBIBVideoData *data = datass[index];
                        data.autoPlayCount = 1;
                        
                         YBImageBrowser *browser = [YBImageBrowser new];
                        //                    // 调低图片的缓存数量
                        //                    browser.ybib_imageCache.imageCacheCountLimit = 100;
                        //                    // 预加载数量设为 0
                                            browser.preloadCount = 5;
                                            
                                            
                                                browser.dataSourceArray = datass;
                                                browser.currentPage = index;
                                                // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//                                                browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                                                [browser show];
                        
                    }
                    
                    
                       
                  
                }else if([UserTools isLogin]){
                    NSLog(@"消耗金币");
//                    [wself useCoinPlay];
                     [HelpTools jianquan:self];
                }else{
                    [HelpTools jianquan:self];
                }
            }

        };
        
        [cell refreshCell:self.dataArr[indexPath.row] index:indexPath.row];
        
        
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 3){
        SessionGifCell *cell = [[SessionGifCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backBlock = ^(id  _Nonnull data) {
            if ([data intValue]==200) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                
                
                
//                if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
                 if ([HelpTools isMemberShip]) {
                ShowGifVC *vc = [[ShowGifVC alloc]init];
                vc.gifString = self.dataArr[indexPath.row].content;
                vc.gifid = self.dataArr[indexPath.row].idss;
                [wself.navigationController pushViewController:vc animated:YES];
                }else if([UserTools isLogin]){
                    NSLog(@"消耗金币");
//                    [wself useCoinPlay];
                     [HelpTools jianquan:self];
                }else{
                    [HelpTools jianquan:self];
                }
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
        
        
              
                         
        
        cell.backBlock = ^(id  _Nonnull data) {
            
            
             if ([HelpTools isMemberShip]) {
//            if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
  //添加图片数据集合
             NSMutableArray *datass = [NSMutableArray array];
            //图片地址集合
            NSMutableArray *urlArr = [NSMutableArray array];
               [self.dataArr enumerateObjectsUsingBlock:^(SessionModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if (obj.ad_type == 0){
                                            // 网络图片
                                          for(NSString *i in obj.images_array ){
                                                YBIBImageData *data = [YBIBImageData new];
                                                 data.imageURL = [NSURL URLWithString:i];
//                                              data.projectiveView = cell.bgImg;
                                  
                                              [urlArr addObject:i];
                                                [datass addObject:data];
                                                }
                               }
                                 }];
                            
                                 NSLog(@"资源里地址是%@",datass[[data intValue]]);
                              NSLog(@"点击的是%lu",(unsigned long)indexPath.row);
                                  NSLog(@"条目有%lu",(unsigned long)self.dataArr.count);
                              NSLog(@"tag是%lu",(unsigned long)[data intValue]);
                              NSLog(@"cell数据有是%@",self.dataArr[indexPath.row].images_array);
            NSString *str = self.dataArr[indexPath.row].images_array[[data intValue]];
                              NSLog(@"选择的图片是%@",self.dataArr[indexPath.row].images_array[[data intValue]]);
            
            //是否包含
                              if ([urlArr containsObject:str]) {
                                  
                                  NSInteger index = [urlArr indexOfObject:str];
                                  NSLog(@"-1---%ld---",index);
                                  
                                   YBImageBrowser *browser = [YBImageBrowser new];
                                  //                    // 调低图片的缓存数量
                                  //                    browser.ybib_imageCache.imageCacheCountLimit = 100;
                                  //                    // 预加载数量设为 0
//                                                      browser.preloadCount = 10;
                                                        browser.webImageMediator = [YBIBDefaultWebImageMediator new];
                                                          browser.dataSourceArray = datass;
                                                          browser.currentPage = index;
                                                          // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                                                          browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                                                          [browser show];
                                  
                              }
                              
             }else if([UserTools isLogin]){
                 NSLog(@"消耗金币");
//                 [wself useCoinPlay];
                  [HelpTools jianquan:self];
             }else{
                 [HelpTools jianquan:self];
             }
            
            
        };
        
        
       
        
        [cell refreshCell:self.dataArr[indexPath.row]];
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 4){
        VoicePlayCell *cell = [[VoicePlayCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshVoice:self.dataArr[indexPath.row]];
        __weak typeof(self) wself = self;
        cell.voicePlayBlock = ^(id  _Nonnull data) {
            
//             if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
                                if ([HelpTools isMemberShip]) {
                                   UIButton *btn = data;
                                   if (btn.isSelected) {
                                       wself.dataArr[indexPath.row].mp3isPlaying = NO;
                                   }else{
                                       wself.dataArr[indexPath.row].mp3isPlaying = YES;
                                   }
                                    
                                    if (wself.saveIndexPath == indexPath) {
                                    [self playButtonAction];

                                     NSLog(@"继续播放");
                                 }else{
                                     wself.mp3String = wself.dataArr[indexPath.row].content;
                                     //当前选中的不等于上次选中的，上次选中的又有，就要消除上次选中的
                                     if (wself.saveIndexPath) {
                                        
                                         VoicePlayCell *cell = [[VoicePlayCell alloc]cellInitWith:tableView Indexpath:wself.saveIndexPath];
                                         [cell.activityIndicator stopAnimating];
                                         
                                         
                                         [self destroyPlayer];
                                         wself.dataArr[wself.saveIndexPath.row].mp3isPlaying = NO;
                                          [wself.tableView reloadRowsAtIndexPaths:@[wself.saveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                         
                                     }
                                     wself.dataArr[indexPath.row].mp3isPlaying = YES;
                                         [self playButtonAction];
                                         wself.saveIndexPath = indexPath;
                                     
                                     [cell.activityIndicator startAnimating];
                                     
                                 }
             
                 
//            UIButton *btn = data;
//            if (btn.isSelected) {
//
//                if (wself.saveIndexPath == indexPath) {
//                    [cell performSelector:@selector(playButtonAction:)];
//                    [wself.audioPlayer pause];
//                    NSLog(@"继续播放");
//                }else{
//                    wself.mp3String = wself.dataArr[indexPath.row].content;
////                    if (wself.saveIndexPath) {
////                        <#statements#>
////                    }
//                    [cell performSelector:@selector(playButtonAction:)];
//
//
//
//                     wself.saveIndexPath = indexPath;
//
////                    if (wself.mp3String.length > 5) {
////                          [wself createStreamer:wself.mp3String];
//////                        [wself.aplayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
////                                          NSLog(@"开始播放声音%@",wself.mp3String);
////
////                        [wself.audioPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
////
////                                          [wself.audioPlayer start];
////
////                                          if (wself.saveIndexPath) {
////                                              wself.dataArr[wself.saveIndexPath.row].mp3isPlaying = NO;
////                                               [wself.tableView reloadRowsAtIndexPaths:@[wself.saveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
////                                          }
////                                          wself.saveIndexPath = indexPath;
////
////                    }else{
////                        wself.dataArr[wself.saveIndexPath.row].mp3isPlaying = NO;
////                        [wself.tableView reloadRowsAtIndexPaths:@[wself.saveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
////                    }
//
//                }
//            }else{
//                wself.saveIndexPath = nil;
//                [wself.audioPlayer pause];
//            }
        }else if([UserTools isLogin]){
            NSLog(@"消耗金币");
//            [wself useCoinPlay];
             [HelpTools jianquan:self];
        }else{
            [HelpTools jianquan:self];
        }
        };
        //抬起闭包
        cell.sliderBlock = ^(NSInteger current) {
            self.dragValue = current;
           [self endSliderScrubbing];

//            [wself.audioPlayer seekToTime:current];
        };
        //按下闭包
        cell.startBlock = ^(NSInteger current) {
                   
            [self beiginSliderScrubbing];
                };
        
        
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 5){
        TextReadCell *cell = [[TextReadCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       [cell refreshCell:self.dataArr[indexPath.row]];
//        cell.titleLab.text = [self.dataArr[indexPath.row].name stringByAppendingString:@".txt"];
        
        return cell;
    }else if(self.dataArr[indexPath.row].ad_type == 6){
        AdCell *cell = [[AdCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCell:self.dataArr[indexPath.row]];
        cell.adBlock = ^(id  _Nonnull data) {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.dataArr[indexPath.row].content] options: @{} completionHandler: nil];

        };
        NSLog(@"广告类型%@",self.dataArr[indexPath.row].mj_JSONString);
        
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
    [self destroyPlayer];
    //    [self removeObserver:self forKeyPath:@"playerStatus"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"停止滑动了：：%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y <= 10) {
//        [self loadMoreData];
//    }
//    
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"拖拽结束：：%f",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y < 50) {
//        [self loadMoreData];
//    }
//   
//}
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

#pragma mark - public

- (id)videoAtIndex:(NSInteger)index {
    SessionVideoCell *cell = (SessionVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell ? cell.videoImg : nil;
}

- (id)voiceAtIndex:(NSInteger)index {
    VoicePlayCell *cell = (VoicePlayCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell ? cell : nil;
}



#pragma mark 初始化播放文件，只允许在播放按钮事件使用
- (void)initMusic {
    self.dragValue = 0;
    self.player = [[AVPlayer alloc]init];
    [self initPlayerItem];
    [self addPlayerListener];
}

//修改playerItem
- (void)initPlayerItem {
    if (self.mp3String && ![self.mp3String isEqualToString:@""]) {
        
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.mp3String]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
}

//添加监听文件,所有的监听
- (void)addPlayerListener {
    
    //自定义播放状态监听
    [self addObserver:self forKeyPath:@"playerStatus" options:NSKeyValueObservingOptionNew context:nil];
    if (self.player) {
        //播放速度监听
        [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (self.playerItem) {
        //播放状态监听
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //缓冲进度监听
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //播放中监听，更新播放进度
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float currentPlayTime = (double)weakSelf.playerItem.currentTime.value/weakSelf.playerItem.currentTime.timescale;
            if (weakSelf.playerItem.currentTime.value<0) {
                currentPlayTime = 0.1; //防止出现时间计算越界问题
            }
            
            
            if(currentPlayTime > 2){
                VoicePlayCell *cell = (VoicePlayCell *)[self.tableView cellForRowAtIndexPath:self.saveIndexPath];
                [cell.activityIndicator stopAnimating];
            }
            
            
            
            NSLog(@"当前播放到:%f",currentPlayTime);
            //拖拽期间不更新数据
            if (!weakSelf.isDragging) {
                VoicePlayCell *cell = (VoicePlayCell *)[self.tableView cellForRowAtIndexPath:self.saveIndexPath];
                cell.progSlider.value = currentPlayTime;
                cell.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(currentPlayTime)/60,lround(currentPlayTime)%60];
            }
        }];
        
    }
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //监听应用后台切换
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //播放中被打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

}



//销毁player,无奈之举 因为avplayeritem的制空后依然缓存的问题。
- (void)destroyPlayer {
    self.dragValue = 0;
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player removeTimeObserver:self.timeObserver];
    
    self.playerItem = nil;
    self.player = nil;
    
    self.playerStatus = VedioStatusPause;
//    self.progSlider.value = 0;
//    self.currentTimeLab.text = @"00:00";
}

- (void)changeMusic {
    if (self.mp3String && ![self.mp3String isEqualToString:@""]) {
        if (self.playerItem && self.player) {
            [self destroyPlayer];
        
        }
    } else {
        [self pause];
    }
}

- (void)changAndPlayMusic {
    if (self.mp3Add && ![self.mp3Add isEqualToString:@""]) {
        
            [self destroyPlayer];
           
            
            [self initMusic];
            [self play];
    
    } else {
        [self pause];
    }

}


#pragma mark 播放，暂停
- (void)play{
    if (self.player && self.playerStatus == VedioStatusPause) {
        NSLog(@"通过播放停止");
        self.playerStatus = VedioStatusBuffering;
        [self.player play];
    }
}

- (void)pause{
    if (self.player && self.playerStatus != VedioStatusPause) {
        NSLog(@"通过暂停停止");
        self.playerStatus = VedioStatusPause;
        [self.player pause];
    }
}

#pragma mark 监听播放完成事件
-(void)playerFinished:(NSNotification *)notification{
    NSLog(@"播放完成");
    [self.playerItem seekToTime:kCMTimeZero];
    [self pause];
}

#pragma mark 播放失败
-(void)playerFailed{
    NSLog(@"播放失败");
     [[MYToast makeText:@"播放失败"]show];
    [self destroyPlayer];
}

#pragma mark 播放被打断
- (void)handleInterruption:(NSNotification *)notification {
    [self pause];
}

#pragma mark 进入后台，暂停音频
- (void)appEnteredBackground {
    [self pause];
}

#pragma mark 监听捕获
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if ([self.playerItem status] == AVPlayerStatusReadyToPlay) {
            //获取音频总长度
            CMTime duration = item.duration;
//            self.progSlider.maximumValue = CMTimeGetSeconds(duration);
            self.maximumValue = CMTimeGetSeconds(duration);
//            self.totalTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(CMTimeGetSeconds(duration))/60,lround(CMTimeGetSeconds(duration))%60];
            NSLog(@"AVPlayerStatusReadyToPlay -- 音频时长%f",CMTimeGetSeconds(duration));
            
        }else if([self.playerItem status] == AVPlayerStatusFailed) {
            
            [self playerFailed];
            NSLog(@"AVPlayerStatusFailed -- 播放异常");
            
        }else if([self.playerItem status] == AVPlayerStatusUnknown) {
            
            [self pause];
            NSLog(@"AVPlayerStatusUnknown -- 未知原因停止");
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        NSArray * array = item.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
//        self.timeSlider.trackValue = totalBuffer;
        //当缓存到位后开启播放，取消loading
        if (totalBuffer >self.dragValue && self.playerStatus != VedioStatusPause) {
            [self.player play];
        }
        NSLog(@"---共缓冲---%.2f",totalBuffer);
    } else if ([keyPath isEqualToString:@"rate"]){
        AVPlayer *item = (AVPlayer *)object;
        if (item.rate == 0) {
            if (self.playerStatus != VedioStatusPause) {
                self.playerStatus = VedioStatusBuffering;
            }
        } else {
            self.playerStatus = VedioStatusPlaying;
            
        }
        NSLog(@"---播放速度---%f",item.rate);
    } else if([keyPath isEqualToString:@"playerStatus"]){
        switch (self.playerStatus) {
            case VedioStatusBuffering:
//                [self.timeSlider.sliderBtn showActivity:YES];
                break;
            case VedioStatusPause:
//                [self.playBtn setImage:[UIImage imageNamed:@"play_mp3icon"] forState:UIControlStateNormal];
//                [self.timeSlider.sliderBtn showActivity:NO];
                break;
            case VedioStatusPlaying:
//                [self.playBtn setImage:[UIImage imageNamed:@"pause_mp3icon"] forState:UIControlStateNormal];
//                [self.timeSlider.sliderBtn showActivity:NO];
                break;

            default:
                break;
        }
    }
}

#pragma mark 监听拖拽事件,拖拽中、拖拽开始、拖拽结束

// 开始拖动
- (void)beiginSliderScrubbing {
    self.isDragging = YES;
}

// 拖动值发生改变
- (void)sliderScrubbing {
    if (self.totalTime != 0) {
//        self.currentTimeLab.text = [NSString stringWithFormat:@"%02ld:%0l2d",lround(self.progSlider.value)/60,lround(self.progSlider.value)%60];
    }
}

// 结束拖动
- (void)endSliderScrubbing {
    self.isDragging = NO;
    CMTime time = CMTimeMake(self.dragValue, 1);
   
    NSLog(@"当前%f",self.dragValue);
    NSLog(@"总%f",self.maximumValue);
     NSLog(@"比%f",self.dragValue/self.maximumValue);
    
    
    if (self.playerStatus != VedioStatusPause) {
        [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//        [self.player pause];
//        [self.playerItem seekToTime:time completionHandler:^(BOOL finished) {
//
//            [self.player play];
//            self.playerStatus = VedioStatusBuffering; //结束拖动后处于一个缓冲状态?如果直接拖到结束呢？
//        }];
    }
}

#pragma mark 播放按钮事件
- (void)playButtonAction {
    if (self.player) {
        if (self.playerStatus == VedioStatusPause) {
            [self play];
        } else {
            [self pause];
        }
    } else {
        [self initMusic];
        [self play];
    }
}




@end
