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
        [self.tempArr addObjectsFromArray:[Array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
        self.dataArr = self.tempArr;
        
        
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
    [self.tableView registerClass:[VoicePlayCell class] forCellReuseIdentifier:@"VoicePlayCell"];
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
                            self.countLabel.text = [NSString stringWithFormat:@"%ld", arr.count];
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

//上拉的时候要加载的
-(void)loadMore{
    
    __weak typeof(self) wself = self;

        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[self.dataArr.count-1].id] current:@"10" page:@"2" Block:^(AppRequestState state, id  _Nonnull result) {
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
   
        [[AppRequest sharedInstance]requestSessionID:self.chatroomId messId:[NSString stringWithFormat:@"%ld", self.dataArr[0].id] current:@"10" page:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
            [wself.tableView.mj_header endRefreshing];
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
// 获取tableView最上面悬停的SectionHeaderView
- (void)getNowTopSectionView {
    NSArray <UITableViewCell *> *cellArray = [self.tableView visibleCells];
//    NSInteger nowSection = -1;
    if (cellArray) {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        nowSection = indexPath.row;
    }
    //滑动到少于4个时就隐藏掉
    if (nowSection >= self.dataArr.count - 4) {
        self.bottomBtn.hidden = YES;
        self.countLabel.hidden = YES;
                                   
    }
    
    NSLog(@"当前滑动到:%ld",nowSection);
    NSLog(@"一共有:%ld",self.dataArr.count);
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
                NSLog(@"视频播放地址：：%@",wself.dataArr[indexPath.row].content);
                if ([HelpTools isMemberShip] || ![CSCaches shareInstance].groupInfoModel.is_allow || [CSCaches shareInstance].groupInfoModel.group_allow ) {
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
                                                data.videoURL = [NSURL URLWithString:obj.content];
//                                                           data.videoURL = [NSURL URLWithString:@"http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4"];
                                                  data.thumbURL = [NSURL URLWithString:obj.images];
                                                data.projectiveView = [self videoAtIndex:idx];
//                                                           data.autoPlayCount = NSUIntegerMax;
                                                           
                                                           [urlArr addObject:obj.content];
                                                [datass addObject:data];
                                                                }
                                                               }];
                  
                    
                     NSLog(@"资源有%lu",(unsigned long)self.datas.count);
                    NSLog(@"点击的是%lu",(unsigned long)indexPath.row);
                        NSLog(@"条目有%lu",(unsigned long)self.dataArr.count);
                    NSLog(@"tag是%lu",(unsigned long)[data intValue]);
                    
                    
                    //是否包含
                    if ([urlArr containsObject:self.dataArr[indexPath.row].content]) {
                        
                        NSInteger index = [urlArr indexOfObject:self.dataArr[indexPath.row].content];
                        NSLog(@"-1---%ld---",index);
                        
                         YBImageBrowser *browser = [YBImageBrowser new];
                        //                    // 调低图片的缓存数量
                        //                    browser.ybib_imageCache.imageCacheCountLimit = 100;
                        //                    // 预加载数量设为 0
                        //                    browser.preloadCount = 10;
                                            
                                            
                                                browser.dataSourceArray = datass;
                                                browser.currentPage = index;
                                                // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                                                browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                                                [browser show];
                        
                    }
                    
                    
                       
                  
                }else if([UserTools isLogin]){
                    NSLog(@"消耗金币");
                    [wself useCoinPlay];
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
        
        
              
                         
        
        cell.backBlock = ^(id  _Nonnull data) {
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
                              
            
        };
        
        
       
        
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


@end
