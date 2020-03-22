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
#import "CopyRightCell.h"

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
//    NSArray *nameArr1 = @[@"到期时间",@"我的金币",@"交易记录",@"我的关注",@"我的收藏",@"观影记录",@"清理缓存"];         //,@"我的缓存"
     NSArray *nameArr1 = @[@"到期时间",@"交易记录",@"我的关注",@"我的收藏",@"观影记录",@"清理缓存"];
//    NSArray *iconArr1 = @[@"timelimit",@"mycoin_icon",@"record_icon",@"myattention",@"mycollectIcon",@"myPostIcon",@"mydownload"];
    NSArray *iconArr1 = @[@"timelimit",@"record_icon",@"myattention",@"mycollectIcon",@"myPostIcon",@"mydownload"];
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
    
//    NSArray *subtitle1 = @[expireTime,[NSString stringWithFormat:@"%ld",(long)[UserTools userBlance]],@"",attention_num,favorite,dis_num,@""];
    NSArray *subtitle1 = @[expireTime,@"",attention_num,favorite,dis_num,@""];

    for (int i = 0; i<nameArr1.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr1[i];
        model.leftTitle = nameArr1[i];
        model.rightTitle = subtitle1[i];
        [arr1 addObject:model];
    }
    
    NSMutableArray *arr2 = [NSMutableArray new];
    NSArray *nameArr2 = @[@"我的金币",@"交易记录"];
    NSArray *iconArr2 = @[@"mycoin_icon",@"record_icon"];
    NSArray *subtitle2 = @[[NSString stringWithFormat:@"%ld",(long)[UserTools userBlance]],@"",@""];
    
    for (int i = 0; i<nameArr2.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr2[i];
        model.leftTitle = nameArr2[i];
        model.rightTitle = subtitle2[i];
        [arr2 addObject:model];
    }
    
    NSMutableArray *arr3 = [NSMutableArray new];
    NSArray *nameArr3 = @[@"官方客服",@"官方QQ",@"官方微信",];
    NSArray *iconArr3 = @[@"serviceIcon",@"QQIcon",@"wechatIcon"];
    NSString *wx = @" ";
       NSString *qq = @" ";
       
       if ([[CSCaches shareInstance]getUserModel:USERMODEL].wx.length > 0) {
           wx = [[CSCaches shareInstance]getUserModel:USERMODEL].wx;
       }
       if ([[CSCaches shareInstance]getUserModel:USERMODEL].qq.length > 0) {
           qq = [[CSCaches shareInstance]getUserModel:USERMODEL].qq;
       }
       
       NSArray *midtitle2 = @[@"",qq,wx,];
       NSArray *btnNameArr = @[@"",@"复制",@"复制"];
    
    
    for (int i = 0; i<nameArr3.count; i++) {
        SetModel *model = [SetModel new];
        model.iconName = iconArr3[i];
        model.leftTitle = nameArr3[i];
        model.midTitle = midtitle2[i];
        model.btnName = btnNameArr[i];
        [arr3 addObject:model];
    }
    
    
    if ([UserTools isLogin]) {
        self.dataArr = @[@[@" "],arr1,arr3,@[@" "],@[@" "]];
    }else{
        self.dataArr = @[@[@" "],arr1,arr3,@[@" "]];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        return 70;
//    }else
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
//    if (section == 1) {
//        UIView *headView = [[UIView alloc]init];
//        headView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-32, 70)];
//        image.image = [UIImage imageNamed:@"share_banner"];
//        [headView addSubview:image];
//        image.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShareImage)];
//        [image addGestureRecognizer:tap];
//        return headView;
//    }else{
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        return headView;
//    }
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
        return 210;
    }else{
        return 55;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        CSMineHeaderCell *cell = [[CSMineHeaderCell alloc]cellInitWith:tableView Indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iconBtn1 addTarget:self action:@selector(handleBtnCliecked1:) forControlEvents:UIControlEventTouchUpInside];
               [cell.iconBtn2 addTarget:self action:@selector(handleBtnCliecked2:) forControlEvents:UIControlEventTouchUpInside];
        [cell refreshInfo:[[CSCaches shareInstance]getUserModel:USERMODEL]];
        return cell;
    }else{
        
        if (indexPath.section == 3) {
            if ([UserTools isLogin]) {
                           //登录了就出现退出登录
            LoginOutCell *cell = [[LoginOutCell alloc]cellInitWith:tableView Indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
                }else{
                    //没登录就出现版权
                    CopyRightCell *cell = [[CopyRightCell alloc]cellInitWith:tableView Indexpath:indexPath];
                               return cell;
                }
        }else if (indexPath.section == 4) {
            CopyRightCell *cell = [[CopyRightCell alloc]cellInitWith:tableView Indexpath:indexPath];
            return cell;
        }else{
            CSMineCell *cell = [[CSMineCell alloc]cellInitWith:tableView Indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            SetModel *model = self.dataArr[indexPath.section][indexPath.row];
            if (indexPath.section == 2) {
                           if (indexPath.row == 1) {
                               [cell messageText:model.midTitle];
                           }else if (indexPath.row == 2){
                               [cell messageText:model.midTitle];
                           }else{
                               [cell messageText:@""];
                           }
                       }
            cell.BtnBlock = ^{
                 NSLog(@"btnBlocc::%ld--%ld--%@",indexPath.section,indexPath.row,model.btnName);
                                          if (indexPath.section == 2 && indexPath.row >= 1) {
                                              UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                              pasteboard.string = model.midTitle;
                                              [[MYToast makeText:@"复制成功"]show];
                                          }
            };

            
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

-(void)handleBtnCliecked1:(UIButton *)sender{
   [[NSNotificationCenter defaultCenter]postNotificationName:@"myViewbt1" object:nil];
  
}
-(void)handleBtnCliecked2:(UIButton *)sender{
  
 [[NSNotificationCenter defaultCenter]postNotificationName:@"myViewbt2" object:nil];
}
@end
