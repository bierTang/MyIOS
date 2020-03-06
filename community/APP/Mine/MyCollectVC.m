//
//  MyCollectVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/27.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "MyCollectVC.h"
#import "MyCollectImgCell.h"

@interface MyCollectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray<CityContentModel *> *dataArr;
@property (nonatomic,strong)NoDataView *nodataView;

@property (nonatomic,assign)NSInteger currentpage;
@property (nonatomic,assign)NSInteger totolPage;

@end

@implementation MyCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = [NSMutableArray new];
    self.currentpage = 1;
    [self initUI];
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestMycollectId:[UserTools userID] page:@"10" current:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"我的收藏");
        if (state == AppRequestState_Success) {
            wself.totolPage = [result[@"data"][@"last_page"] integerValue];
             wself.dataArr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            [wself.tableView reloadData];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyCollectImgCell class] forCellReuseIdentifier:@"MyCollectImgCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 666;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(BottomSpaceHight);
    }];
    
//    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(Headerfresh)];
//    self.tableView.mj_header=header;
//    [header setTitle:@"刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
//    header.lastUpdatedTimeLabel.hidden=YES;
    
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
    self.tableView.mj_footer=footer;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
    self.nodataView = [[NoDataView alloc]initWithTitle:@"暂无收藏内容"];
    [self.view addSubview:self.nodataView];
    [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(300);
        make.centerY.equalTo(self.view.centerY);
    }];
}

-(void)Headerfresh{
    
    [self.tableView.mj_header endRefreshing];
}
-(void)footerLoad{
    if (self.totolPage > self.currentpage) {
        self.currentpage ++;
        __weak typeof(self) wself = self;
        [[AppRequest sharedInstance]requestMycollectId:[UserTools userID] page:@"10" current:[NSString stringWithFormat:@"%ld",self.currentpage] Block:^(AppRequestState state, id  _Nonnull result) {
            NSLog(@"我的收藏");
            if (state == AppRequestState_Success) {
                wself.totolPage = [result[@"data"][@"last_page"] integerValue];
                 [wself.dataArr addObjectsFromArray: [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]]];
                [wself.tableView reloadData];
            }
            [wself.tableView.mj_footer endRefreshing];
        }];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
#pragma mark --tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    
    MyCollectImgCell *cell = [[MyCollectImgCell alloc]cellInitWith:tableView Indexpath:indexPath];
    [cell refreshModel:self.dataArr[indexPath.row]];
    
    cell.backBlock = ^(id  _Nonnull data) {
        UIButton *btn = data;
        if (btn.tag == 66) {
            //删除
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除该收藏？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [wself.tableView beginUpdates];
                [[AppRequest sharedInstance]requestDeleteMyCollectById:wself.dataArr[indexPath.row].idss Block:^(AppRequestState state, id  _Nonnull result) {
                    if (state == AppRequestState_Success) {
                        //
                    }
                }];
                [wself.dataArr removeObject:wself.dataArr[indexPath.row]];
                [wself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [wself.tableView endUpdates];
                
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            wself.dataArr[indexPath.row].isFold = btn.isSelected ? @(1) : @(0);
            [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [wself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    };
    
    cell.videoBlock = ^(id  _Nonnull data) {
        CSVideoPlayVC *vc = [[CSVideoPlayVC alloc]init];
        vc.playUrl = wself.dataArr[indexPath.row].video;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [wself presentViewController:vc animated:YES completion:nil];
        
    };
    
    return cell;
    
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"收藏的：%@",[self.dataArr[indexPath.row] mj_JSONString]);
}


@end
