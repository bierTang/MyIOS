//
//  OfficialMineView.m
//  community
//
//  Created by 蔡文练 on 2019/11/8.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "OfficialMineView.h"
#import "SetModel.h"
#import "CSMineCell.h"
#import "CSMineHeaderCell.h"
#import "LoginOutCell.h"

@implementation OfficialMineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    [self loadDataArr];
    
    self.tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self addSubview:self.tableview];
    
}

-(void)loadDataArr{
    ////数据源设置
    NSMutableArray *arr1 = [NSMutableArray new];
    NSArray *nameArr1 = @[@"我的关注",@"我的收藏",@"观影记录",@"到期时间",@"清理缓存"];         //,@"我的缓存"
    NSArray *iconArr1 = @[@"myattention",@"mycollectIcon",@"myPostIcon",@"timelimit",@"mydownload"];
    NSString *expireTime = [HelpTools dateStampWithTime:[[[CSCaches shareInstance]getUserModel:USERMODEL].expiration_time intValue] andFormat:@"YYYY-MM-dd"];
    NSString *attention_num = @"0";
    if ([[[CSCaches shareInstance]getUserModel:USERMODEL].attention_num intValue] > 0) {
        attention_num = [[CSCaches shareInstance]getUserModel:USERMODEL].attention_num;
    }
    NSString *favorite = @"0";
    if ([[[CSCaches shareInstance]getUserModel:USERMODEL].favorite_num intValue] > 0) {
        favorite = [[CSCaches shareInstance]getUserModel:USERMODEL].favorite_num;
    }
    
    NSString *dis_num = @" ";   //观影记录数
    if ([[CSCaches shareInstance]getUserModel:USERMODEL].discover_num.length > 0) {
//        dis_num = [[CSCaches shareInstance]getUserModel:USERMODEL].discover_num;
    }
    
    NSArray *subtitle1 = @[attention_num,favorite,dis_num,expireTime,@""];
    for (int i = 0; i<nameArr1.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr1[i];
        model.leftTitle = nameArr1[i];
        model.rightTitle = subtitle1[i];
        [arr1 addObject:model];
    }
    
    NSMutableArray *arr2 = [NSMutableArray new];
    NSArray *nameArr2 = @[@"我的金币",@"购买商城",@"交易记录"];
    NSArray *iconArr2 = @[@"mycoin_icon",@"mall_icon",@"record_icon"];
    NSArray *subtitle2 = @[[NSString stringWithFormat:@"%ld",[UserTools userBlance]],@"",@""];
    
    for (int i = 0; i<nameArr2.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr2[i];
        model.leftTitle = nameArr2[i];
        model.rightTitle = subtitle2[i];
        [arr2 addObject:model];
    }
    
    NSMutableArray *arr3 = [NSMutableArray new];
    NSArray *nameArr3 = @[@"官方客服",@"分享推广"];
    NSArray *iconArr3 = @[@"serviceIcon",@"share_icon"];
    for (int i = 0; i<nameArr3.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr3[i];
        model.leftTitle = nameArr3[i];
        [arr3 addObject:model];
    }
    
    
    if ([UserTools isLogin]) {
        self.dataArr = @[@[@" "],arr1,arr2,arr3,@[@" "]];
    }else{
        self.dataArr = @[@[@" "],arr1,arr2,arr3];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 70;
    }else
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 70)];
        image.image = [UIImage imageNamed:@"share_banner"];
        [headView addSubview:image];
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareImage)];
        [image addGestureRecognizer:tap];
        return headView;
    }else{
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        return headView;
    }
}
-(void)tapShareImage{
    if (self.cellBlock) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
        self.cellBlock(indexPath);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else{
        return 55;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        CSMineHeaderCell *cell = [[CSMineHeaderCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreshInfo:[[CSCaches shareInstance]getUserModel:USERMODEL]];
        return cell;
    }else{
        
        if (indexPath.section == 4) {
            LoginOutCell *cell = [[LoginOutCell alloc]cellInitWith:tableView Indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CSMineCell *cell = [[CSMineCell alloc]cellInitWith:tableView Indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SetModel *model = self.dataArr[indexPath.section][indexPath.row];
            [cell refreshCellIcon:model.iconName andTitle:model.leftTitle subtitle:model.rightTitle funBtnTitle:model.btnName];
            
            return cell;
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellBlock) {
        self.cellBlock(indexPath);
    }
}

-(void)reloadData{
    [self loadDataArr];
    [self.tableview reloadData];
}


@end
