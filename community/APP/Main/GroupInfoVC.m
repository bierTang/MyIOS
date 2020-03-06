//
//  GroupInfoVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "GroupInfoVC.h"
#import "GroupInfoCell.h"
#import "GroupMemberCell.h"
#import "GroupIntroduceVC.h"

@interface GroupInfoVC () <UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)UIScrollView *bgScrollView;
//
//@property (nonatomic,strong)MemberView *memberView;
//
//@property (nonatomic,strong)UIView *infoView;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)NSArray *subArr;
@property (nonatomic,strong)NSArray *memBerArr;

@property (nonatomic,assign)NSInteger memberNum;

@end

@implementation GroupInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [[AppRequest sharedInstance]requestGroupMemBer:[CSCaches shareInstance].groupInfoModel.idss Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"群成员::%@",result);
        self.memBerArr = [UserModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
        self.memberNum = [result[@"data"][@"count"] integerValue];
        [self.tableView reloadData];
    }];
}

-(void)initUI{
    self.dataArr = @[@[@"a"],@[@"群名称",@"所属板块",@"群介绍"],@[@"投诉"]];
    self.subArr = @[@[@"a"],@[[CSCaches shareInstance].groupInfoModel.name,@"暂无",@""],@[@""]];

    [self.view addSubview:self.tableView];
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [ UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[GroupInfoCell class] forCellReuseIdentifier:@"GroupInfoCell"];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200*K_SCALE;
    }else{
        return 44*K_SCALE;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GroupMemberCell *cell = [[GroupMemberCell alloc]cellInitWith:tableView Indexpath:indexPath];
        [cell refreshCell:self.memBerArr memBerNum:self.memberNum];
        return cell;
    }else{
        GroupInfoCell *cell = [[GroupInfoCell alloc]cellInitWith:tableView Indexpath:indexPath];
        
        [cell refreshCell:self.dataArr[indexPath.section][indexPath.row] subtitle:self.subArr[indexPath.section][indexPath.row] showArrow:YES];
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        //
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = @"群介绍";
        
        GroupIntroduceVC *vc = [[GroupIntroduceVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row ==0){///投诉
//        WebServeVC *vc = [[WebServeVC alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = @"在线客服";
        WebServeVC *vc = [[WebServeVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
