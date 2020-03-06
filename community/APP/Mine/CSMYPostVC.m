//
//  CSMineSecurityVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/10.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSMYPostVC.h"
#import "CSMyPostCell.h"

@interface CSMYPostVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)NSMutableArray<CityContentModel *> *dataArr;

@property (nonatomic,strong)NoDataView *nodataView;
@property (nonatomic,assign)NSInteger currentpage;
@property (nonatomic,assign)NSInteger totolPage;
@end

@implementation CSMYPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.currentpage = 1;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CSMyPostCell class] forCellReuseIdentifier:@"CSMyPostCell"];
    [self.view addSubview:self.tableview];
    [self.tableview makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.topMargin.equalTo(0);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableview.estimatedRowHeight = 200;
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestMyPost:[UserTools userID] current:@"1" page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            wself.totolPage = [result[@"data"][@"last_page"] integerValue];
            wself.dataArr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
            [wself.tableview reloadData];
        }
    }];
    
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoad)];
    self.tableview.mj_footer=footer;
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    
    self.nodataView = [[NoDataView alloc]initWithTitle:@"暂未发布内容"];
    [self.view addSubview:self.nodataView];
    [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(300);
        make.centerY.equalTo(self.view.centerY);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)footerLoad{
    if (self.totolPage > self.currentpage) {
        self.currentpage ++;
        __weak typeof(self) wself = self;
        [[AppRequest sharedInstance]requestMyPost:[UserTools userID] current:[NSString stringWithFormat:@"%ld",self.currentpage] page:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
               if (state == AppRequestState_Success) {
                   [wself.dataArr addObjectsFromArray:[CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]]];
                   [wself.tableview reloadData];
               }
            [wself.tableview.mj_footer endRefreshing];
           }];
       
    }else{
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMyPostCell *cell = [[CSMyPostCell alloc]cellInitWith:tableView Indexpath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.row]];
    __weak typeof(self) wself = self;
    cell.backBlock = ^(id  _Nonnull data) {
            UIButton *btn = data;
        if (btn.tag == 66) {
            //删除
            NSLog(@"de::%ld--%@",indexPath.row,self.dataArr);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除这条动态？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [wself.tableview beginUpdates];
                [[AppRequest sharedInstance]requestDeleteMyPostdisId:wself.dataArr[indexPath.row].idss Block:^(AppRequestState state, id  _Nonnull result) {
                    if (state == AppRequestState_Success) {
                        //
                    }
                }];
                [wself.dataArr removeObject:wself.dataArr[indexPath.row]];
                [wself.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [wself.tableview endUpdates];
               
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            NSLog(@"dd:::%ld",btn.tag);
            wself.dataArr[indexPath.row].isFold = btn.isSelected ? @(1) : @(0);
            [wself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            [wself.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        };
        
        cell.videoBlock = ^(id  _Nonnull data) {
            CSVideoPlayVC *vc = [[CSVideoPlayVC alloc]init];
            vc.playUrl = [NSString stringWithFormat:@"%@%@",mainHost,wself.dataArr[indexPath.row].video];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [wself presentViewController:vc animated:YES completion:nil];
            
        };
    
    return cell;
}


@end
