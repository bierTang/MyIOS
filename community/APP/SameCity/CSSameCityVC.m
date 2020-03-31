//
//  CSSameCityVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/6.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSSameCityVC.h"
#import "CSMomentCell.h"

@interface CSSameCityVC ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray<CityContentModel *> *dataArr;

@property (nonatomic,assign)NSInteger currentpage;
@property (nonatomic,assign)NSInteger totalPage;

@property (nonatomic,strong)UIImageView *nodataImg;

@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIView *navBgView;

@property (nonatomic,strong)UIButton *attentionBtn;


@end

@implementation CSSameCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.dataArr = [NSMutableArray new];
    self.currentpage = 1;
    [self initUI];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, ItemSpaceHight, 44, 24);
    
    [self.backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self loadData];
    
    self.nodataImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData"]];
    [self.view addSubview:self.nodataImg];
    self.nodataImg.hidden = YES;
    self.nodataImg.center = self.view.center;
    
    self.navBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:self.navBgView];
    self.navBgView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.navBgView.alpha = 0;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 44, 44);
    
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [self.navBgView addSubview:btn];
    [btn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [UILabel labelWithTitle:@"同城" font:15 textColor:@"181818" textAlignment:NSTextAlignmentLeft];
    [self.navBgView addSubview:lab];
    lab.frame = CGRectMake(35, 20, 100, 44);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/all_po" Params:@{@"city_id":wself.cityModel.idss,@"user_id":[UserTools userID] ? [UserTools userID]:@"",@"current":@(wself.currentpage),@"page":@"10"} Callback:^(BOOL isSuccess, id result) {
        NSLog(@"同城：：%@---%@",result,result[@"msg"]);
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        if (isSuccess) {
            wself.totalPage = [result[@"data"][@"last_page"] integerValue];
            if ([result[@"code"] integerValue]== 200) {
                
                wself.attentionBtn.selected = [result[@"data"][@"is_attention"] boolValue];
                wself.dataArr = [CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
                
                [wself.tableview reloadData];
            }
        }
        
    } HttpMethod:AppRequestPost isAni:YES];
}

-(void)Headerfresh{
    [self.tableview.mj_header endRefreshing];
    [self loadData];
}
-(void)footerLoad{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    
    if (self.currentpage < self.totalPage) {
        self.currentpage ++;
        [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/all_po" Params:@{@"city_id":wself.cityModel.idss,@"user_id":[UserTools userID] ? [UserTools userID]:@"",@"current":@(wself.currentpage),@"page":@"10"} Callback:^(BOOL isSuccess, id result) {
            NSLog(@"同城：：%@---%@",result,result[@"msg"]);
            [MBProgressHUD hideHUDForView:wself.view animated:YES];
            if ([wself.tableview.mj_footer isRefreshing]) {
                [wself.tableview.mj_footer endRefreshing];
            }
            if (isSuccess) {
                wself.totalPage = [result[@"data"][@"last_page"] integerValue];
                if ([result[@"code"] integerValue]== 200) {
                    [wself.dataArr addObjectsFromArray:[CityContentModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]]];
                    
                    [wself.tableview reloadData];
                }else{
                    [[MYToast makeText:result[@"msg"]]show];
                }
            }else{
                [[MYToast makeText:@"网络请求失败"]show];
            }
            
        } HttpMethod:AppRequestPost isAni:YES];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark -- tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nodataImg.hidden = self.dataArr.count > 0 ? YES:NO;
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSMomentCell *cell = [[CSMomentCell alloc]cellInitWith:tableView Indexpath:indexPath];
    cell.requstStr = @"/index.php/index/Post/is_favorite";
    cell.model = self.dataArr[indexPath.row];
    
    __weak typeof(self) wself = self;
    cell.backBlock = ^(id  _Nonnull data) {
        UIButton *btn = data;
        wself.dataArr[indexPath.row].isFold = btn.isSelected ? @(1) : @(0);
        [wself.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [wself.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
    
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 234;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [UIView new];
//    view.backgroundColor = RGBColor(9, 198, 106);
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderViewID"];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderViewID"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
        UIView *bgView = [[UIView alloc]initWithFrame:headerView.bounds];
        bgView.backgroundColor = RGBColor(9, 198, 106);
        [headerView addSubview:bgView];
        bgView.clipsToBounds = YES;
        
        ////
        UILabel *cityLab = [UILabel labelWithTitle:self.cityModel.name font:16 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        [headerView addSubview:cityLab];
        
        [cityLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(70);
        }];
        
        UILabel *verifyLab = [UILabel labelWithTitle:@"认证版块" font:12 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        [headerView addSubview:verifyLab];
        
        [verifyLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cityLab.right).offset(5);
            make.centerY.equalTo(cityLab.centerY);
        }];
        
        UILabel *postlab = [UILabel labelWithTitle:[NSString stringWithFormat:@"帖数：%@",self.cityModel.post_num] font:12 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        [headerView addSubview:postlab];
        
        [postlab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(cityLab.bottom).offset(8);
        }];
        
        ///关注
        if (!self.attentionBtn) {
            self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.attentionBtn setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
            [self.attentionBtn setImage:[UIImage imageNamed:@"hadattention"] forState:UIControlStateSelected];
            [headerView addSubview:self.attentionBtn];
            
            [self.attentionBtn addTarget:self action:@selector(addAttention:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.attentionBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(85);
                make.right.equalTo(-16);
            }];
        }
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 80)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 20;
        [bgView addSubview:whiteView];
        
        UILabel *lab = [UILabel labelWithTitle:@"广场" font:16 textColor:@"181818" textAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:lab];
        
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(15);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH-32, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        [whiteView addSubview:line];
    }
    return headerView;
}

-(void)addAttention:(UIButton *)sender{
    if (![UserTools isLogin]) {
         [[MYToast makeText:@"未登录"]show];
         return;
     }
    
    sender.selected = !sender.isSelected;
    
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/Post/is_attention" Params:@{@"user_id":[UserTools userID] ? [UserTools userID]:@"",@"city_id":self.cityModel.idss} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            //
            NSLog(@"关注：%@--%@",result,result[@"msg"]);
        }
    } HttpMethod:AppRequestPost isAni:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    BOOL isShowPersonPage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowPersonPage animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 100) {
        self.backBtn.alpha = 0;
        self.navBgView.alpha = 1-1/(scrollView.contentOffset.y - 100);
    }else{
        self.navBgView.alpha=0;
        self.backBtn.alpha = 1;
    }
    
    
}

@end
