//
//  CSMineViewController.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//
//oc中使用swift
#import "community-Bridging-Header.h"
#import "微群社区-Swift.h"


#import "CSMineViewController.h"
#import "CSMineCell.h"
#import "CSMineHeaderCell.h"
#import "CSMYPostVC.h"
#import "SetModel.h"
#import "CSCityListVC.h"
#import "MyCollectVC.h"
#import "CSMyInfoVC.h"
#import "LoginOutCell.h"
#import "CardActivateView.h"

#import "OfficialMineView.h"
#import "CSRecordVC.h"
#import "CSShareVC.h"
#import "RecommedVC.h"

@interface CSMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,strong)CardActivateView *cardActView;

@property (nonatomic,strong)OfficialMineView *officeView;
@end

@implementation CSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (![UserTools isAgentVersion]) {
        self.officeView = [[OfficialMineView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.officeView];
        __weak typeof(self) wself = self;
        self.officeView.cellBlock = ^(id  _Nonnull data) {
            [wself tableView:wself.officeView.tableview didSelectRowAtIndexPath:data];
        };
    }else{
        [self refreshData];
        [self.view addSubview:self.tableView];
        
        [self requestNewData];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestNewData) name:NOT_FRESHMYINFO object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addBtnEvent) name:@"myViewEnterServeWeb" object:nil];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleBtnCliecked1) name:@"myViewbt1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleBtnCliecked2) name:@"myViewbt2" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenWrong_Loginout) name:NOT_TOKENWRONG object:nil];
}

-(void)addBtnEvent{
    NSLog(@"add");

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"在线客服";
    WebServeVC *vc = [[WebServeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)reLoadinfo{
    if (![UserTools isAgentVersion]) {
        //判断不是代理的页面是否存在
        if(![self.officeView isDescendantOfView:self.view]){
            self.officeView = [[OfficialMineView alloc]initWithFrame:self.view.bounds];
                   [self.view addSubview:self.officeView];
                   __weak typeof(self) wself = self;
                   self.officeView.cellBlock = ^(id  _Nonnull data) {
                       [wself tableView:wself.officeView.tableview didSelectRowAtIndexPath:data];
                   };
        }else{
            self.officeView.hidden = NO;
        }
        //判断代理页面是否存在
        if(self.tableView){
            self.tableView.hidden = YES;
            
        }
        
        [self.officeView reloadData];
    }else{
        [self refreshData];
        //判断代理页面是否存在
        if(![self.tableView isDescendantOfView:self.view]){
            [self.view addSubview:self.tableView];
        }else{
            self.tableView.hidden = NO;
        }
        //判断不是代理的页面是否存在
        if(self.officeView){
            self.officeView.hidden = YES;
            
        }
        
         [self.tableView reloadData];

        
        
        
    }
}
-(void)refreshData{
    ////数据源设置
    NSMutableArray *arr1 = [NSMutableArray new];
    NSArray *nameArr1 = @[@"我的关注",@"我的收藏",@"观影记录",@"清理缓存",@"分享推广"];         //,@"我的缓存"
    NSArray *iconArr1 = @[@"myattention",@"mycollectIcon",@"myPostIcon",@"mydownload",@"share_icon"];
    NSString *attention_num = @"0";
    if ([[[CSCaches shareInstance]getUserModel:USERMODEL].attention_num intValue] > 0) {
        attention_num = [[CSCaches shareInstance]getUserModel:USERMODEL].attention_num;
    }
    NSString *favorite = @"0";
    if ([[[CSCaches shareInstance]getUserModel:USERMODEL].favorite_num intValue] > 0) {
        favorite = [[CSCaches shareInstance]getUserModel:USERMODEL].favorite_num;
    }
    NSString *dis_num = @" ";  //观影记录数
    if ([[CSCaches shareInstance]getUserModel:USERMODEL].discover_num.length > 0) {
//        dis_num = [[CSCaches shareInstance]getUserModel:USERMODEL].discover_num;
    }
    NSArray *subtitle1 = @[attention_num,favorite,dis_num,@"",@"",@""];
    for (int i = 0; i<nameArr1.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr1[i];
        model.leftTitle = nameArr1[i];
        model.rightTitle = subtitle1[i];
        [arr1 addObject:model];
    }
    
    
    NSMutableArray *arr2 = [NSMutableArray new];
    NSArray *nameArr2 = @[@"到期时间",@"您专属客服QQ",@"您专属客服微信"];
    NSArray *iconArr2 = @[@"timelimit",@"QQIcon",@"wechatIcon"];
    
    NSString *expireTime = [HelpTools dateStampWithTime:[[[CSCaches shareInstance]getUserModel:USERMODEL].expiration_time intValue] andFormat:@"YYYY-MM-dd"];
    NSString *wx = @" ";
    NSString *qq = @" ";
    
    if ([[CSCaches shareInstance]getUserModel:USERMODEL].wx.length > 0) {
        wx = [[CSCaches shareInstance]getUserModel:USERMODEL].wx;
    }
    if ([[CSCaches shareInstance]getUserModel:USERMODEL].qq.length > 0) {
        qq = [[CSCaches shareInstance]getUserModel:USERMODEL].qq;
    }
    NSArray *subtitle2 = @[expireTime,@"",@""];
    NSArray *midtitle2 = @[@"",qq,wx,];
    NSArray *btnNameArr = @[@"",@"复制",@"复制"];

    for (int i = 0; i<nameArr2.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr2[i];
        model.leftTitle = nameArr2[i];
        model.rightTitle = subtitle2[i];
        model.midTitle = midtitle2[i];
        model.btnName = btnNameArr[i];
        [arr2 addObject:model];
    }
    
    self.dataArr = @[@[@" "],arr2,arr1,@[@" "]];
    
    if ([UserTools isLogin]) {
        self.dataArr = @[@[@" "],arr2,arr1,@[@" "]];
    }else{
        self.dataArr = @[@[@" "],arr2,arr1];
    }

//    for (id s self.dataArr) {
//      NSLog(@"%@",s);
//    }

    
    NSLog(@"当前的内容%lu", (unsigned long)self.dataArr.count);
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    if (![UserTools isAgentVersion]) {
//        [self.officeView reloadData];
//    }else{
//        [self.tableView reloadData];
//    }
    [self requestNewData];
}
-(void)requestNewData{
    if ([UserTools isLogin]) {
        __weak typeof(self) wself = self;
        [[AppRequest sharedInstance]requestGetMyinfo:[UserTools userID] Block:^(AppRequestState state, id  _Nonnull result) {
             [wself reLoadinfo];
            NSLog(@"个人信息::%@--%@",result,result[@"msg"]);
           
            
        }];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [ UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else
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
        return 210;
    }else{
        return 55;
    }
}
-(void)handleBtnCliecked1{
    if (![UserTools isLogin]) {
        
            CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

            [self.navigationController pushViewController:vc animated:YES];
       
        return;
    }
    
    
    if (![UserTools isAgentVersion]) {
        CSShareVC *vc = [[CSShareVC alloc]init];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = @"我的";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (!self.cardActView) {
            self.cardActView = [[CardActivateView alloc]init];
            [[UIApplication sharedApplication].keyWindow addSubview:self.cardActView];
            [self.cardActView makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.top.bottom.equalTo(0);
            }];
        }
        self.cardActView.inputTF.text = @"";
        self.cardActView.hidden = NO;
    }
    
    
    NSLog(@"激活");
  
}
-(void)handleBtnCliecked2{
    
    if (![UserTools isLogin]) {
        
            CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

            [self.navigationController pushViewController:vc animated:YES];
      
        return;
    }
    
    NSLog(@"购买");
   if (![UserTools isAgentVersion]) {
//       CSMallVC *vc = [[CSMallVC alloc]init];
//       [self.navigationController pushViewController:vc animated:YES];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
             self.navigationItem.backBarButtonItem = barItem;
             barItem.title = @"我的";
             KamiPayController *vc = [[ KamiPayController alloc]init];
             [self.navigationController pushViewController:vc animated:YES];
//       [self presentViewController:vc  animated:YES completion:nil];
   }else{
       UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
       self.navigationItem.backBarButtonItem = barItem;
       barItem.title = @"我的";
       KamiPayController *vc = [[ KamiPayController alloc]init];
       [self.navigationController pushViewController:vc animated:YES];
//       [self presentViewController:vc  animated:YES completion:nil];
   }
    
    
    
    
    
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetModel *model11 = self.dataArr[indexPath.section][indexPath.row];
    NSLog(@"内容%@",model11);
    
    if (indexPath.section == 0 ) {
        CSMineHeaderCell *cell = [[CSMineHeaderCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshInfo:[[CSCaches shareInstance]getUserModel:USERMODEL]];
        
        
        [cell.iconBtn1 addTarget:self action:@selector(handleBtnCliecked1) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconBtn2 addTarget:self action:@selector(handleBtnCliecked2) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        
        if (indexPath.section == 3) {
            LoginOutCell *cell = [[LoginOutCell alloc]cellInitWith:tableView Indexpath:indexPath];
            return cell;
        }else{
            CSMineCell *cell = [[CSMineCell alloc]cellInitWith:tableView Indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SetModel *model = self.dataArr[indexPath.section][indexPath.row];
            [cell refreshCellIcon:model.iconName andTitle:model.leftTitle subtitle:model.rightTitle funBtnTitle:model.btnName];
            if (indexPath.section == 1) {
                if (indexPath.row == 1) {
                    [cell messageText:model.midTitle];
                }else if (indexPath.row == 2){
                    [cell messageText:model.midTitle];
                }else{
                    [cell messageText:@""];
                }
            }else if(indexPath.section == 2){
                [cell messageText:@""];
            }
            cell.BtnBlock = ^{
                NSLog(@"btnBlocc::%ld--%ld--%@",indexPath.section,indexPath.row,model.btnName);
                if (indexPath.section == 1 && indexPath.row >= 1) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = model.midTitle;
                    [[MYToast makeText:@"复制成功"]show];
                }
//                else if (indexPath.section == 1 && indexPath.row == 0){
//                    if (!self.cardActView) {
//                        self.cardActView = [[CardActivateView alloc]init];
//                        [[UIApplication sharedApplication].keyWindow addSubview:self.cardActView];
//                        [self.cardActView makeConstraints:^(MASConstraintMaker *make) {
//                            make.left.right.equalTo(0);
//                            make.top.bottom.equalTo(0);
//                        }];
//                    }
//                    self.cardActView.inputTF.text = @"";
//                    self.cardActView.hidden = NO;
//                }
            };
            return cell;
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![UserTools isLogin]) {
        if (indexPath.row == 0) {
            CSMyverifyVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyverifyVC"];

            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [HelpTools jianquan:self];
        }
        return;
    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    if (![UserTools isAgentVersion]) {
        self.dataArr = self.officeView.dataArr;
    }
    if (indexPath.section !=0 && indexPath.section != self.dataArr.count-1) {
        SetModel *model = self.dataArr[indexPath.section][indexPath.row];
        if (model && model.leftTitle) {
            barItem.title = model.leftTitle;
        }
    }
    
    if (indexPath.section == 0) {
        NSLog(@"1111");
//        NSDictionary *param = @{@"mobile":@"15283908173",@"password":@"123456"};
//        [[AppRequest sharedInstance]requestLogin:@"15283908173" password:@"123456" Block:^(AppRequestState state, id  _Nonnull result) {
//            NSLog(@"登录");
//        }];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = @"个人信息";
        
        CSMyInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSMyInfoVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if(indexPath.section == 2 && [UserTools isAgentVersion]){
        
        NSLog(@"2222");
        
        if (indexPath.row == 2) {
            NSLog(@"我的发布改成了历史记录");
//            CSMYPostVC *vc = [[CSMYPostVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            RecommedVC *reVC = [[RecommedVC alloc]init];
            reVC.type = @"1888";
            [self.navigationController pushViewController:reVC animated:YES];
            
            
        }else if (indexPath.row == 0){
            //我的关注
            CSCityListVC *vc = [[CSCityListVC alloc]init];
            vc.isMyAttention = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            //我的收藏
            MyCollectVC *vc = [[MyCollectVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row ==3 && [UserTools isAgentVersion]){
            NSLog(@"缓存1");
            [self clearCaches];
        }else if (indexPath.row ==4){
            NSLog(@"分享");
//            [self clearCaches];
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.backBarButtonItem = barItem;
            barItem.title = @"我的";
            CSShareVC *vc = [[CSShareVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if(indexPath.section == 1 && ![UserTools isAgentVersion]){
            //官方版本
            NSLog(@"2222");
            if (indexPath.row == 1) {
               NSLog(@"记录");
              CSRecordVC *vc = [[CSRecordVC alloc]init];
              [self.navigationController pushViewController:vc animated:YES];
            }else
            if (indexPath.row == 4) {
                NSLog(@"我的发布改成了历史记录");
    //            CSMYPostVC *vc = [[CSMYPostVC alloc]init];
    //            [self.navigationController pushViewController:vc animated:YES];
                
                RecommedVC *reVC = [[RecommedVC alloc]init];
                reVC.type = @"1888";
                [self.navigationController pushViewController:reVC animated:YES];
                
                
            }else if (indexPath.row == 2){
                //我的关注
                CSCityListVC *vc = [[CSCityListVC alloc]init];
                vc.isMyAttention = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 3){
                //我的收藏
                MyCollectVC *vc = [[MyCollectVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row ==5 && [UserTools isAgentVersion]){
                NSLog(@"缓存1");
                [self clearCaches];
            }else if (indexPath.row ==5){
                NSLog(@"缓存");
                [self clearCaches];
            }
            
        }else{
        ///官方版本
        if (![UserTools isAgentVersion]) {
            if (indexPath.section == 3) {
                [self showLoginOut];
            }
           else if (indexPath.section == 2){
                if (indexPath.row == 0) {
                    NSLog(@"客服系统");
                    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
                    self.navigationItem.backBarButtonItem = barItem;
                    barItem.title = @"在线客服";
                    WebServeVC *vc = [[WebServeVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
//                    [self presentViewController:vc animated:YES completion:nil];
                }else{
                    NSLog(@"分享推广");
                    CSShareVC *vc = [[CSShareVC alloc]init];
                    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
                    self.navigationItem.backBarButtonItem = barItem;
                    barItem.title = @"我的";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else{///代理版本
            if(indexPath.section == 1){
                if (indexPath.row == 1) {
//                    CSMallVC *vc = [[CSMallVC alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
                }else if (indexPath.row == 2){
                    NSLog(@"记录");
//                    CSRecordVC *vc = [[CSRecordVC alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
                }}else
                    if(indexPath.section == 3){
                        NSLog(@"退出");
                        [self showLoginOut];
                    }
        }
        
    }
        
}


///清楚缓存
-(void)clearCaches{
    NSString *cachesSize = [NSString stringWithFormat:@"将有%@的缓存被清理",[HelpTools getCachesSize]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:cachesSize preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认清理" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [HelpTools clearAppCaches];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showLoginOut{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [UserTools loginOut];
        [self reLoadinfo];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tokenWrong_Loginout{
    [UserTools loginOut];
    [self reLoadinfo];
}


@end
