//
//  CSDiscoverVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/15.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSDiscoverVC.h"
#import "CSMomentCell.h"
#import "CSPostContentVC.h"


@interface CSDiscoverVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray<CityContentModel *> *dataArr;

@property (nonatomic,assign)NSInteger currentpage;
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,strong)NoDataView *nodataView;

@end

@implementation CSDiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray new];
    [self initUI];
//
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"postContentIcon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPostVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.bottom.equalTo(-80-KBottomSafeArea);
    }];
    
    self.currentpage = 1;
    [[AppRequest sharedInstance]requestdiscoverCurrent:@"1" page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            self.totalPage = [result[@"data"][@"last_page"] integerValue];
            self.dataArr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            if (self.dataArr.count > 0) {
                self.tableview.mj_footer.hidden = NO;
            }else{
                self.tableview.mj_footer.hidden = YES;
            }
            [self.tableview reloadData];
        }
    }];
    
    self.nodataView = [[NoDataView alloc]initWithTitle:@"暂无内容，快去发一条吧"];
    [self.view addSubview:self.nodataView];
    [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(150);
        make.centerY.equalTo(self.view.centerY);
    }];
    
}
-(void)goToPostVC{
    NSLog(@"去发布");
    CSPostContentVC *vc = [[CSPostContentVC alloc]init];
    vc.navigationItem.leftBarButtonItem.title = @"发布";
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)initUI{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[CSMomentCell class] forCellReuseIdentifier:@"CSMomentCell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //    self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
        make.bottom.equalTo(BottomSpaceHight);
    }];
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(Headerfresh)];
    self.tableview.mj_header=header;
    [header setTitle:@"刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
    
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
    self.tableview.mj_footer=footer;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
    
}
-(void)Headerfresh{
    
    self.currentpage = 1;
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestdiscoverCurrent:@"1" page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        [wself.tableview.mj_header endRefreshing];
        if (state == AppRequestState_Success) {
            wself.totalPage = [result[@"data"][@"last_page"] integerValue];
            wself.dataArr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            [wself.tableview reloadData];
        }
    }];
}
-(void)footerLoad{
//    NSLog(@"cccccuuurent::%ld---%ld",self.currentpage,self.totalPage);
        if (self.currentpage == self.totalPage) {
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }else{
            __weak typeof(self) wself = self;
            self.currentpage++;
            [[AppRequest sharedInstance]requestdiscoverCurrent:[NSString stringWithFormat:@"%d",self.currentpage] page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
                [wself.tableview.mj_footer endRefreshing];
                if (state == AppRequestState_Success) {
                    NSArray *arr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                    [wself.dataArr addObjectsFromArray:arr];
                    [wself.tableview reloadData];
                }
            }];
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
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMomentCell *cell = [[CSMomentCell alloc]cellInitWith:tableView Indexpath:indexPath];
    cell.requstStr = @"/index.php/index/discover/discover_is_favorite";
    cell.model = self.dataArr[indexPath.row];
    
    __weak typeof(self) wself = self;
    cell.backBlock = ^(id  _Nonnull data) {
        UIButton *btn = data;
        wself.dataArr[indexPath.row].isFold = btn.isSelected ? @(1) : @(0);
        [wself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [wself.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
    
    cell.videoBlock = ^(id  _Nonnull data) {
//        NSLog(@"视频播放：：%@",self.dataArr[indexPath.row].video);
        CSVideoPlayVC *vc = [[CSVideoPlayVC alloc]init];
        vc.playUrl = wself.dataArr[indexPath.row].video;//[NSString stringWithFormat:@"%@%@",mainHost,wself.dataArr[indexPath.row].video];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [wself presentViewController:vc animated:YES completion:nil];
        
    };
    
    return cell;
}

@end
