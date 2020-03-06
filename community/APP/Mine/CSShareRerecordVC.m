//
//  CSShareRerecordVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSShareRerecordVC.h"
#import "ShareRecordCell.h"

@interface CSShareRerecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NoDataView *nodataView;
@end

@implementation CSShareRerecordVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请记录";
    
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
//    shareBgimage@2x
    UIView *bgWhite = [[UIView alloc]init];
    bgWhite.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgWhite];
    
    [bgWhite makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(152);
    }];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shareBgimage"]];
    [bgWhite addSubview:bgImg];
    [bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgWhite.centerX);
        make.centerY.equalTo(bgWhite.centerY);
    }];
    
    UILabel *label = [UILabel labelWithTitle:@"我的邀请" font:18 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [bgImg addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.centerX.equalTo(bgImg.centerX);
    }];
    
    UILabel *leftNum = [UILabel labelWithTitle:@"0" font:18 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [bgImg addSubview:leftNum];
    
    [leftNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(bgImg).multipliedBy(0.5);
        make.centerY.equalTo(bgImg.centerY);
    }];
    
    UILabel *leftname = [UILabel labelWithTitle:@"邀请好友" font:12 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [bgImg addSubview:leftname];
    
    [leftname makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(bgImg).multipliedBy(0.5);
        make.top.equalTo(leftNum.bottom).offset(4);
    }];
    
    UILabel *rightNum = [UILabel labelWithTitle:@"0" font:18 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [bgImg addSubview:rightNum];
    
    [rightNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.width.equalTo(bgImg).multipliedBy(0.5);
        make.centerY.equalTo(bgImg.centerY);
    }];
    
    UILabel *rightname = [UILabel labelWithTitle:@"剩余时间" font:12 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [bgImg addSubview:rightname];
    
    [rightname makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.width.equalTo(bgImg).multipliedBy(0.5);
        make.top.equalTo(leftNum.bottom).offset(4);
    }];
    
    UIView *shu = [[UIView alloc]init];
    shu.backgroundColor = [UIColor whiteColor];
    [bgImg addSubview:shu];
    [shu makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(0.5);
        make.height.equalTo(28*K_SCALE);
        make.top.equalTo(50*K_SCALE);
        make.centerX.equalTo(bgImg.centerX);
    }];
    
    
    
    [self.tableView registerClass:[ShareRecordCell class] forCellReuseIdentifier:@"ShareRecordCell"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgWhite.bottom).offset(9);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestShopRecord:[UserTools userID] curentpage:@"1" counts:@"10" Block:^(AppRequestState state, id  _Nonnull result) {
        
        if (state == AppRequestState_Success) {
          
            [wself.tableView reloadData];
        }
        
    }];
    
    
    self.nodataView = [[NoDataView alloc]initWithTitle:@"暂无有效推广用户"];
    [self.view addSubview:self.nodataView];
    [self.nodataView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(300);
        make.centerY.equalTo(self.view.centerY);
    }];
    
    
    [[AppRequest sharedInstance]requestShareRecord:[UserTools userID] page:@"10" current:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"邀请记录：：%@--%@",result,result[@"msg"]);
        leftNum.text = [NSString stringWithFormat:@"%@",result[@"data"][@"total"]];
        rightNum.text = result[@"data"][@"expiration_time"];
        self.dataArr = [CSRecordModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
        [self.tableView reloadData];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nodataView.hidden = self.dataArr.count;
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLab = [UILabel labelWithTitle:@"邀请好友" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    nameLab.font = [UIFont boldSystemFontOfSize:14];
    [headView addSubview:nameLab];
    [nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(headView.centerY);
    }];
    
    UILabel *timeLab = [UILabel labelWithTitle:@"获得时长" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    timeLab.font = [UIFont boldSystemFontOfSize:14];
    [headView addSubview:timeLab];
    [timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(headView.centerY);
    }];
    
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareRecordCell *cell = [[ShareRecordCell alloc]cellInitWith:tableView Indexpath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.row]];
    
    return cell;
}

@end
