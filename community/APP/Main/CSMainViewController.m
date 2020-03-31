//
//  CSMainViewController.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//


//log输出解决 xcode8 log 显示不全
#ifdef DEBUG
#define QMLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define QMLog(format, ...)
#endif


#import "CSMainViewController.h"
#import "CSChatListCell.h"
//#import "EMChatroomsViewController.h"
#import "YLLoopScrollView.h"
#import "YLCustomView.h"
#import "CSSearchViewController.h"
#import "OpenInstallSDK.h"

@interface CSMainViewController ()<UITableViewDelegate,UITableViewDataSource,MLEmojiLabelDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray<ChatListModel *> *dataArr;

@property (nonatomic,strong)YLLoopScrollView *ylScrollview;

@property (nonatomic,assign)NSInteger formCount;

@property (nonatomic,strong)UIView *promotView;

@property (nonatomic,copy)NSString *updateUrl;

@property (weak, nonatomic) IBOutlet UILabel *boardTitleLab;

@property (weak, nonatomic) IBOutlet MLEmojiLabel *boardContentLab;

@property (weak, nonatomic) IBOutlet UIButton *boardConfirnBtn;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation CSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formCount = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[CSChatListCell class] forCellReuseIdentifier:@"CSChatListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //去掉横线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(125*K_SCALE);
        make.bottom.equalTo(-KTabBarHeight);
    }];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header=header;
    [header setTitle:@"刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
 
    [self setUpNav];
    
//    [self loadData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateChange) name:NOT_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateChange) name:NOT_FRESHMYINFO object:nil];
    
//    [[CSCaches shareInstance]saveUserDefalt:AGENTID value:@"3"];
    ///4LSDBY
    if (![UserTools isAgentVersion]) {
        [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
            if (appData.data) {//(动态安装参数)
                if (appData.data[@"agent_code"]) {
                    [[CSCaches shareInstance]saveUserDefalt:AGENTID value:appData.data[@"agent_code"]];
                }
                if (appData.data[@"user_code"]) {
                    [[CSCaches shareInstance]saveUserDefalt:SHAREUSER value:appData.data[@"user_code"]];
                }
            }
        }];
    }
//    [[CSCaches shareInstance]saveUserDefalt:AGENTID value:@"4LSDBY"];
    
//    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //2.添加任务到队列中，就可以执行任务
//    dispatch_async(queue, ^{
//        NSLog(@"下载图片1----%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"下载图片2----%@",[NSThread currentThread]);
//    });
//
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestUpdateBlock:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"版本更新:%@",result);
        if (state == AppRequestState_Success) {
            NSInteger sver = [result[@"data"][@"version"]integerValue];
            NSInteger bver = [HelpTools getAPPVersion].integerValue;
            if (sver > bver) {
                //需要更新
                NSString *urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&amp;url=%@",result[@"data"][@"down_url"]];
                NSLog(@"xiazai::%@",urlString);
                wself.updateUrl = urlString;
//                NSURL *url  = [NSURL URLWithString:urlString];
//                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                MBProgressHUD *hud =[[MBProgressHUD alloc]init];
                [wself.view addSubview:hud];
                
                wself.promotView.hidden = NO;
                wself.boardTitleLab.text = @"版本更新";
                wself.boardContentLab.text = result[@"data"][@"info"];
                [wself.updateBtn setTitle:@"立即下载" forState:UIControlStateNormal];
                
            }else{
                [wself RequstBoardTitle];
            }
        }else{
            [self RequstBoardTitle];
        }
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenWrong_Loginout) name:NOT_TOKENWRONG object:nil];
    
    
    // 创建定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(startimer) userInfo:nil repeats:YES];
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    // 停止定时器
//    [timer invalidate];
    [timer fire];
    
}
//开始计时
-(void)startimer{
    if (![UserTools userID]) {
        NSLog(@"没有登录");
        return ;
    }
    [[AppRequest sharedInstance]requestGetMyinfo:[UserTools userID] Block:^(AppRequestState state, id  _Nonnull result) {
        
        NSLog(@"更新个人信息::%@--%@",result,result[@"msg"]);
                   
    }];
}
-(void)tokenWrong_Loginout{
    [UserTools loginOut];
//    [[MYToast makeText:@"登录失效，请重新登录"]show];
}
-(void)viewWillAppear:(BOOL)animated{
    
        FMDatabase *fmdb = [CSDataBase creatDataBase];
        if (fmdb) {
            [CSDataBase creatAppDataBaseTable];
        }
    
    [self loadData];
}
-(void)RequstBoardTitle{
    ///公共栏 通知
        [[AppRequest sharedInstance]requestBoardBlock:^(AppRequestState state, id  _Nonnull result) {
    //        if (state == AppRequestState_Success) {
                NSLog(@"公告::%@",result[@"msg"]);
                if ([result[@"data"][@"status"] intValue]==1) {
                    self.promotView.hidden = NO;
                    self.boardTitleLab.text = result[@"data"][@"title"];
                    self.boardContentLab.delegate = self;
                    self.boardContentLab.text = result[@"data"][@"content"];
                }
    //        }
        }];
}


-(UIView *)promotView{
    if (!_promotView) {
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgview.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:bgview];
//        [self.view addSubview:bgview];
        _promotView = [[NSBundle mainBundle]loadNibNamed:@"BoardView" owner:self options:nil][0];
        [bgview addSubview:_promotView];
        _promotView.layer.cornerRadius = 4;
        _promotView.clipsToBounds = YES;
        _promotView.center = CGPointMake(self.view.center.x, self.view.center.y);
        
        _boardConfirnBtn.layer.cornerRadius = 22;
        _boardConfirnBtn.clipsToBounds = YES;
    }
    return _promotView;
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (![link hasPrefix:@"http"]) {
        link = [NSString stringWithFormat:@"http://%@",link];
    }
    NSLog(@"linkeeee::%@",link);
    if (link.length > 5 && ([link containsString:@"www"]||[link containsString:@"http"])) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link]];
        }
    }
}

- (IBAction)hiddenBorad:(id)sender {
    [self.promotView.superview removeFromSuperview];
    
    if (self.updateUrl.length > 8) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl] options:@{} completionHandler:nil];
    }
}


-(void)loginStateChange{
    [self loadData];
}

-(void)loadData{
//    NSString *jsonCode =  [CSDataBase cacheDataByCacheType:DB_MainAds Identify:@"MainAds" versionCode:@"1"];
//    NSArray *Array = [jsonCode  mj_JSONObject];
//    if (Array.count > 0 && !self.ylScrollview) {
//        NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:Array];
//        [self initScrollAds:arr];
//    }
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestChatList:@"1" Page:@"50" Block:^(AppRequestState state, id  _Nonnull result) {
        QMLog(@"请求聊天列表：%@",result);
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        if ([wself.tableView.mj_header isRefreshing]) {
            [wself.tableView.mj_header endRefreshing];
        }
        if (state == AppRequestState_Success) {
            wself.formCount = [result[@"data"][@"mapCount"] intValue];
            wself.dataArr = [ChatListModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            [wself.tableView reloadData];
            if(result[@"data"][@"ad_lists"]){
                
                if (!wself.ylScrollview) {
                    NSArray *arr = [YLCustomViewModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"ad_lists"]];
                    
                    if (arr.count > 0) {
                        [CSDataBase insertCacheDataByIdentify:@"MainAds" CacheType:DB_MainAds versionCode:@"1" data:[result[@"data"][@"ad_lists"] mj_JSONString]];
                   if (!wself.ylScrollview) {
                       [wself initScrollAds:arr];
                   }
                    }else{
                        [self.tableView updateConstraints:^(MASConstraintMaker *make) {
                            make.right.left.equalTo(0);
                            make.top.equalTo(0);
                            make.bottom.equalTo(-KTabBarHeight);
                        }];
                    }
                    
                    
                }
            }
        }else{
            //[[MYToast makeText:@"列表获取失败"]show];
        }
    }];
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
    
    self.ylScrollview.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];//RGBColor(245, 162, 0);
    self.ylScrollview.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.ylScrollview.frame = CGRectMake(0,0,SCREEN_WIDTH,125*K_SCALE);
    [self.view addSubview:self.ylScrollview];
    
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
                       make.right.left.equalTo(0);
                       make.top.equalTo(125*K_SCALE);
                       make.bottom.equalTo(-KTabBarHeight);
                   }];
    
}
-(void)setUpNav{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 30, 44)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"nav_icon_search"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(mainAndSearchBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 35, 44)];
    [rightButtonView addSubview:addBtn];
    [addBtn setImage:[UIImage imageNamed:@"service_nav"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    if ([UserTools isAgentVersion]) {
        addBtn.hidden = YES;
        mainAndSearchBtn.frame = CGRectMake(50, 0, 35, 44);
    }
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
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
-(void)mainAndSearchBtnEvent{
    NSLog(@"search");
    CSSearchViewController *vc = [[CSSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 25;
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.formCount>0 && indexPath.row == self.formCount-1) {
        return 70*K_SCALE;
    }else{
        return 60*K_SCALE;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSChatListCell  *cell = [[CSChatListCell alloc]cellInitWith:tableView Indexpath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell refreshCell:self.dataArr[indexPath.row]];
    if (indexPath.row < self.formCount) {
        cell.freeLab.hidden = NO;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.formCount) {
        self.dataArr[indexPath.row].isFreeGroup = YES;
    }else{
        self.dataArr[indexPath.row].isFreeGroup = NO;
    }
        [CSCaches shareInstance].groupInfoModel = self.dataArr[indexPath.row];
        CSChatSessionVC *vc = [[CSChatSessionVC alloc]init];
        vc.chatroomId = self.dataArr[indexPath.row].idss;
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = self.dataArr[indexPath.row].name;
        
        [self.navigationController pushViewController:vc animated:YES];
        
//        return;
//    }
//
//    if ((self.dataArr[indexPath.row].is_allow == NO || self.dataArr[indexPath.row].group_allow) && [UserTools isLogin]) {
//        CSChatSessionVC *vc = [[CSChatSessionVC alloc]init];
//        vc.chatroomId = self.dataArr[indexPath.row].idss;
//
//        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
//        self.navigationItem.backBarButtonItem = barItem;
//        barItem.title = self.dataArr[indexPath.row].name;
//
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//
//
//    BOOL conti = [HelpTools jianquan:self];
//    if (conti == NO) {
//        return;
//    }
//
//       if (![HelpTools isMemberShip] && [UserTools userBlance] > 0){
//           __weak typeof(self) wself = self;
//           NSString *warnStr = [NSString stringWithFormat:@"您未开通本站会员，将消耗%ld金币进入该群",self.dataArr[indexPath.row].need_coin];
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的权限不足" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
//
//               UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//                   [[AppRequest sharedInstance]requestEnterGroupByCoinID:self.dataArr[indexPath.row].idss Block:^(AppRequestState state, id  _Nonnull result) {
//                       NSLog(@"aaa:::%@--%@",result,result[@"msg"]);
//                       if (state == AppRequestState_Success) {
//                           [[MYToast makeText:@"购买成功，进入该群"]show];
//
//                           CSChatSessionVC *vc = [[CSChatSessionVC alloc]init];
//                           vc.chatroomId = wself.dataArr[indexPath.row].idss;
//
//                           UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
//                           wself.navigationItem.backBarButtonItem = barItem;
//                           barItem.title = wself.dataArr[indexPath.row].name;
//
//                           [wself.navigationController pushViewController:vc animated:YES];
//
//                           [wself loadData];
//                       }else if (result[@"msg"]){
//                           [[MYToast makeText:result[@"msg"]]show];
//                       }else{
//                           [[MYToast makeText:@"购买失败"]show];
//                       }
//                   }];
//
//               }];
//               UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                   NSLog(@"cancel");
//               }];
//               [alert addAction:action1];
//               [alert addAction:action2];
//
//               [self presentViewController:alert animated:YES completion:nil];
//
//       }else{
//
//           CSChatSessionVC *vc = [[CSChatSessionVC alloc]init];
//           vc.chatroomId = self.dataArr[indexPath.row].idss;
//
//           UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
//           self.navigationItem.backBarButtonItem = barItem;
//           barItem.title = self.dataArr[indexPath.row].name;
//
//           [self.navigationController pushViewController:vc animated:YES];
//       }
//
       
}


//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一个不需要侧滑
    if(indexPath.row == 0){
        return NO;
    }else{
        //没有登录不需要置顶
           if (![UserTools isLogin]) {
               return NO;
           }else{
               return YES;
           }
        
    }
    
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *topRowAction;
    if ([self.dataArr[indexPath.row].group_status  isEqual: @"1"]) {
       topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                [[AppRequest sharedInstance]requestGroupTop:self.dataArr[indexPath.row].idss userid:[UserTools userID] status:@"0" Block:^(AppRequestState state, id  _Nonnull result) {
                    [self loadData];
                }];
           }];
    }else{
        topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                    [[AppRequest sharedInstance]requestGroupTop:self.dataArr[indexPath.row].idss userid:[UserTools userID] status:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
                        [self loadData];
                    }];
               }];
        
        
    
    }
    // 添加一个编辑按钮
    
    topRowAction.backgroundColor = [UIColor colorWithHexString:@"999999"];
    // 将设置好的按钮放到数组中返回
    return @[topRowAction];
}

@end
