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

@property (nonatomic,strong)UISwitch *aswitch;
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
    self.dataArr = @[@[@"a"],@[@"群名称",@"所属板块",@"群聊置顶",@"群介绍"],@[@"投诉"]];
    NSString *gName = [CSCaches shareInstance].groupInfoModel.group_name;
    self.subArr = @[@[@"a"],@[[CSCaches shareInstance].groupInfoModel.name,gName ? gName:@"暂无",@"",@""],@[@""]];
    self.navigationItem.title = [CSCaches shareInstance].groupInfoModel.name;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
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
        NSLog(@"状态%ld",self.memberNum);
        NSLog(@"状态%ld",self.memberNum/5);
        return 725*K_SCALE;
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
        
        
//        NSLog(@"状态%@",[CSCaches shareInstance].groupInfoModel.group_status);
        NSString *str = [CSCaches shareInstance].groupInfoModel.group_status;
        if ([str  isEqual: @"1"]) {
            cell.aswitch.on = YES;
        }else{
            cell.aswitch.on = NO;
        }
        self.aswitch = cell.aswitch;
        // 添加事件
        [cell.aswitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 3) {
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


// switch改变
-(void)switchChange:(id)sender{
   UISwitch* openbutton = (UISwitch*)sender;
   Boolean ison = openbutton.isOn;
    if(![UserTools userID]){
               openbutton.on = NO;
               [[MYToast makeText:@"请先登录"]show];
           }
    if(ison){
        NSLog(@"打开了");
        
        [[AppRequest sharedInstance]requestGroupTop:[CSCaches shareInstance].groupInfoModel.idss userid:[UserTools userID] status:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
            
        }];
  
        
        
        
    }else{
        NSLog(@"关闭了");
        
        [[AppRequest sharedInstance]requestGroupTop:[CSCaches shareInstance].groupInfoModel.idss userid:[UserTools userID] status:@"0" Block:^(AppRequestState state, id  _Nonnull result) {
            
        }];
    }
}


@end
