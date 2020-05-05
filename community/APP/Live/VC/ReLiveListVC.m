//
//  LiveRecommandVC.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "ReLiveListVC.h"
#import "LiveListView.h"
#import "LivePlayVC.h"

#import "PingdaoModel.h"
@interface ReLiveListVC ()

//@property (nonatomic,strong)YLLoopScrollView *ylScrollview;
@property (nonatomic,strong)LiveListView *liveView;

@end

@implementation ReLiveListVC
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self initUI];
}
-(void)initUI{
    
        self.liveView = [[LiveListView alloc]init];
   
        self.liveView.showHeader = NO;
 
        
        [self addChildViewController:self.liveView];
        [self.view addSubview:self.liveView.view];
        
        self.liveView.liveBlock = ^(LiveModel * _Nonnull model) {
            if ([HelpTools isMemberShip]) {
                LivePlayVC *liveVC = [[LivePlayVC alloc]init];
                liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
                
                liveVC.model = model;
                [self presentViewController:liveVC animated:YES completion:nil];
            }else{
//                if (![UserTools isAgentVersion]) {
                    [HelpTools jianquan:self];
//                }
//                else{
//                    [[MYToast makeText:@"请先开通会员"]show];
//                }
            }
        };
    

        [self.liveView.view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshData)];
       [header setTitle:@"刷新" forState:MJRefreshStateIdle];
       [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
       [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
       self.liveView.collectionView.mj_header = header;
        
        [self requestData];
}
-(void)freshData{
    [self requestData];
}
-(void)requestData{
    [[AppRequest sharedInstance]requestLiveListPingdao:self.model.pull pass:self.model.pass Block:^(AppRequestState state, id  _Nonnull result) {
             NSLog(@"aa");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.liveView.collectionView.mj_header isRefreshing]) {
                [self.liveView.collectionView.mj_header endRefreshing];
            }
        });
        
             if (state == AppRequestState_Success) {
                 //遍历赋值
                 NSArray<PingdaoModel *> *arr;
                 //data存在取data
                 if (result[@"data"]) {
                     arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                     //arr为空代表不是data里面直接是数组
                     if (!arr) {
                         if (result[@"data"][@"info"][0]) {
                             arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"info"][0][@"list"]];
                         }
                         
                     }
                     
                 }
                 
                 //可能是大众频道的数据
                 if(!arr){
                     arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"zhubo"]];
                 }
                 if(!arr){
                     arr =  [PingdaoModel mj_objectArrayWithKeyValuesArray:result[@"list"]];
                 }
                 NSMutableArray<LiveModel *> *mos = [NSMutableArray array];
                  for (PingdaoModel *str in arr) {
                     LiveModel *mo = [[LiveModel alloc]init];
                     if(str.cover.length > 1){
                        mo.imgUrl = str.cover;
                     }else if(str.headimage.length > 1){
                        mo.imgUrl = str.headimage;
                     }else if(str.avatar.length > 1){
                        mo.imgUrl = str.avatar;
                     }else{
                         mo.imgUrl = str.img;
                     }
                      if(str.title.length > 1){
                          mo.userName = str.title;
                      }else if(str.user_nicename.length > 1){
                          mo.userName = str.user_nicename;
                      }else{
                          mo.userName = str.name;
                      }
                     
                     
                      if (str.video.length > 1) {
                          mo.pull = str.video;
                      }else if (str.address.length > 1) {
                          mo.pull = str.address;
                      }else{
                          mo.pull = str.pull;
                      }
                      if (str.city.length > 1) {
                          mo.city = str.city;
                      }else{
                          mo.city = @"";
                      }
                      
                      if (str.Popularity.length > 1) {
                         mo.nums = str.Popularity;
                     }else if (str.nums.length > 1) {
                         mo.nums = str.nums;
                     }else{
                         mo.nums = @"";
                     }
                      
                      [mos addObject:mo];
                  }
                 
                 [self.liveView reLoadCollectionView:mos];
             }
         }];
}


@end
