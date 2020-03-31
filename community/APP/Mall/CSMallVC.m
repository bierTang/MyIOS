//
//  CSMallVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/7.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSMallVC.h"

@interface CSMallVC ()

@property (nonatomic,strong)NSArray<CardModel *> *dataArr;


@property (nonatomic,strong)NSArray<CardModel *> *coindataArr;

@end

@implementation CSMallVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *green = [[UIView alloc]initWithFrame:CGRectMake(16, 11*K_SCALE, 2*K_SCALE, 10*K_SCALE)];
    green.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self.view addSubview:green];
    
    UILabel *lab = [UILabel labelWithTitle:@"购买会员" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    lab.frame = CGRectMake(24*K_SCALE, 6*K_SCALE, 100*K_SCALE, 20*K_SCALE);
    [self.view addSubview:lab];
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestMerBerCardListBlock:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            wself.dataArr = [CardModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
            wself.coindataArr = [CardModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"coin_list"]];
            [wself creatCardList];
        }
    }];
    
}
-(void)creatCardList{
    for (int i=0; i<self.dataArr.count; i++) {

        UIImageView *cardImg = [[UIImageView alloc]initWithFrame:CGRectMake(16+178*K_SCALE*(i%2),32*K_SCALE + K_SCALE* 99*(i/2), 166*K_SCALE, 87*K_SCALE)];
        [cardImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,self.dataArr[i].images]] placeholderImage:[UIImage imageNamed:@"dayCard_1"]];
        cardImg.userInteractionEnabled = YES;
        cardImg.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleMemberCard:)];
        [cardImg addGestureRecognizer:tap];
        [self.view addSubview:cardImg];
        
        UILabel *priceLab = [UILabel labelWithTitle:[NSString stringWithFormat:@"%ld",self.dataArr[i].coin] font:22*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        [cardImg addSubview:priceLab];
        [priceLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(11*K_SCALE);
            make.top.equalTo(55*K_SCALE);
        }];
        
        UILabel *coinLab = [UILabel labelWithTitle:@"金币" font:11*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        [cardImg addSubview:coinLab];
        [coinLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLab.right).offset(2);
            make.bottom.equalTo(priceLab.bottom).offset(-3);
        }];
        
        
    }
    
    
    UIView *green = [[UIView alloc]initWithFrame:CGRectMake(16, 140*K_SCALE + K_SCALE* 99*(self.dataArr.count/2), 2*K_SCALE, 10*K_SCALE)];
    green.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self.view addSubview:green];
    
    UILabel *lab = [UILabel labelWithTitle:@"购买金币" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    lab.frame = CGRectMake(24*K_SCALE, 135*K_SCALE + K_SCALE* 99*(self.dataArr.count/2), 100*K_SCALE, 20*K_SCALE);
    [self.view addSubview:lab];
    
    for (int k=0; k<self.coindataArr.count; k++) {

        UIImageView *cardImg = [[UIImageView alloc]initWithFrame:CGRectMake(16+178*K_SCALE*(k%2),165*K_SCALE + K_SCALE* 95*(self.dataArr.count/2) + K_SCALE* 99*(k/2), 166*K_SCALE, 83*K_SCALE)];
        [cardImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,self.coindataArr[k].path]] placeholderImage:[UIImage imageNamed:@"dayCard_1"]];

        cardImg.userInteractionEnabled = YES;
        cardImg.tag = 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCoin)];
        [cardImg addGestureRecognizer:tap];
        [self.view addSubview:cardImg];
    }
    
}

-(void)handleMemberCard:(UITapGestureRecognizer *)tap{
    
    CardModel *model = self.dataArr[tap.view.tag];
    NSString *warnStr =[NSString stringWithFormat:@"将消耗%ld金币",model.coin];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买会员" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[AppRequest sharedInstance]requestMerBerShip:[UserTools userID] type:model.idss number:@"1" Block:^(AppRequestState state, id  _Nonnull result) {
            if (state == AppRequestState_Success) {
                [[MYToast makeText:@"购买成功"]show];
                [[CSCaches shareInstance]saveUserDefalt:USERBLANCE value:result[@"data"][@"user_coin"]];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOT_FRESHMYINFO object:nil];
            }else if (result[@"msg"]){
                [[MYToast makeText:result[@"msg"]]show];
            }else{
                [[MYToast makeText:@"购买失败"]show];
            }
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)handleCoin{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"联系在线客服购买" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        WebServeVC *vc = [[WebServeVC alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = barItem;
        barItem.title = @"在线客服";
        WebServeVC *vc = [[WebServeVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
//    [HelpTools jumpToQQ:serverQQ];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
