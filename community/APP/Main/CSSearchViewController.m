//
//  CSSearchViewController.m
//  community
//
//  Created by 蔡文练 on 2019/10/11.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSSearchViewController.h"
#import "CSChatListCell.h"
#import "HotWordModel.h"

@interface CSSearchViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITextField *searchTF;
@property(nonatomic,strong)UIView *hotView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray<ChatListModel *> *dataArr;
@property (nonatomic,strong)NSArray<HotWordModel *> *hotwordArr;

@property (nonatomic,assign)BOOL checkMore;

@end

@implementation CSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self setupNav];
    [self initUI];
    
    [[AppRequest sharedInstance]requestHotWordsListBlock:^(AppRequestState state, id  _Nonnull result) {
        self.hotwordArr = [HotWordModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        if (self.hotwordArr.count > 0) {
            [self initHotwordsBtn];
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)setupNav{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(310*K_SCALE + 16, ItemSpaceHight, 44, 30*K_SCALE);
    
    [cancelBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"53668A"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(16, ItemSpaceHight, 300*K_SCALE, 30*K_SCALE)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    bgView.layer.cornerRadius = 2;
    bgView.clipsToBounds = YES;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*K_SCALE, 7*K_SCALE, 16*K_SCALE, 16*K_SCALE)];
    searchImg.image = [UIImage imageNamed:@"searchIcon"];
    [bgView addSubview:searchImg];
    
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(26*K_SCALE, 0, 300*K_SCALE, 30*K_SCALE)];
    [bgView addSubview:self.searchTF];
    self.searchTF.placeholder = @"搜索";
    self.searchTF.font = [UIFont systemFontOfSize:16*K_SCALE];
    
    [self.searchTF addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventEditingChanged];
    
    
}

-(void)searchAction:(UITextField *)textfield{
    NSLog(@"搜索：：%@",textfield.text);
    if (textfield.text.length > 0) {
        self.tableView.hidden = NO;
    }else{
        self.tableView.hidden = YES;
    }
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestSearchList:textfield.text showAll:@"0" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"返回search::%@",result);
        wself.dataArr = [ChatListModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
        
        wself.checkMore = [result[@"data"][@"count"] integerValue] >= 5 ? YES : NO;
        
        [wself.tableView reloadData];
        
    }];
    
}
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initUI{
    
    self.hotView = [[UIView alloc]initWithFrame:CGRectMake(0, ItemSpaceHight+50, SCREEN_WIDTH, 300)];
//    self.hotView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.hotView];
    
//    self.hotView
    
    UILabel *titleLab = [UILabel labelWithTitle:@"热门搜索内容" font:15*K_SCALE textColor:@"6e6e6e" textAlignment:NSTextAlignmentCenter];
    titleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [self.hotView addSubview:titleLab];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[CSChatListCell class] forCellReuseIdentifier:@"CSChatListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(ItemSpaceHight+50);
        make.bottom.equalTo(-KTabBarHeight);
    }];
    
    self.tableView.hidden = YES;
    
}
-(void)initHotwordsBtn{
    
    for (int i=0; i < self.hotwordArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(55*K_SCALE+105*(i%3)*K_SCALE, 40+40*(i/3), 65*K_SCALE, 30);
        [self.hotView addSubview:btn];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16*K_SCALE];
        [btn setTitleColor:[UIColor colorWithHexString:@"09c66a"] forState:UIControlStateNormal];
        [btn setTitle:self.hotwordArr[i].keyword forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hotWordsSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)hotWordsSelect:(UIButton *)sender{
    
    UITextField *tf = [[UITextField alloc]init];
    tf.text = self.hotwordArr[sender.tag].keyword;
    [self searchAction:tf];
}


#pragma mark -tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    self.tableView.hidden = !self.dataArr.count;
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSChatListCell  *cell = [[CSChatListCell alloc]cellInitWith:tableView Indexpath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell  refreshCell:self.dataArr[indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [CSCaches shareInstance].groupInfoModel = self.dataArr[indexPath.row];
    CSChatSessionVC *vc = [[CSChatSessionVC alloc]init];
    vc.chatroomId = self.dataArr[indexPath.row].idss;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = self.dataArr[indexPath.row].name;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
   
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.clipsToBounds = YES;
    UILabel *lab = [UILabel labelWithTitle:@"聊天室" font:12*K_SCALE textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    lab.frame = CGRectMake(16, 0, 100, 30);
    [view addSubview:lab];
    
    UILabel *lab2 = [UILabel labelWithTitle:@"暂无内容" font:12*K_SCALE textColor:@"6e6e6e" textAlignment:NSTextAlignmentLeft];
    lab2.frame = CGRectMake(16, 30, 100, 30);
    [view addSubview:lab2];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArr.count==0) {
        return 60;
    }else
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.clipsToBounds = YES;
    UIImageView *check = [[UIImageView alloc]init];
    check.image = [UIImage imageNamed:@"checkMore_icon"];
    [view addSubview:check];
    [check makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(view.centerY);
    }];
    
    UIButton *btn = [UIButton buttonWithTitle:@"查看更多" font:12*K_SCALE titleColor:@"09c66a"];
    [view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(check.right).offset(5);
        make.centerY.equalTo(view.centerY);
    }];
    
    [btn addTarget:self action:@selector(showAllResult) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

///查看全部
-(void)showAllResult{

    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestSearchList:self.searchTF.text showAll:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"返回search::%@",result);
        wself.dataArr = [ChatListModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"lists"]];
        
        wself.checkMore = NO;
        
        [wself.tableView reloadData];
        
        
    }];
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.checkMore) {
        return 30;
    }else
    return 0.001;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    NSLog(@"ff");
}
@end
