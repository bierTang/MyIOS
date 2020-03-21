//
//  CardActivateView.m
//  community
//
//  Created by 蔡文练 on 2019/11/4.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CardActivateView.h"

@implementation CardActivateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(275*K_SCALE);
        make.height.equalTo(140*K_SCALE);
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
    }];
    
    UILabel *title = [UILabel labelWithTitle:@"请输入激活码" font:16 textColor:@"181818" textAlignment:NSTextAlignmentCenter];
    [self.bgView addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.centerX.equalTo(self.bgView.centerX);
    }];
    
    self.inputTF = [[UITextField alloc]init];
    self.inputTF.placeholder = @"请输入您购买的激活码";
    self.inputTF.font = [UIFont systemFontOfSize:16*K_SCALE];
    [self.bgView addSubview:self.inputTF];
    
    [self.inputTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.right.equalTo(-18);
        make.top.equalTo(50);
        make.height.equalTo(30);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self.bgView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.bottom).offset(5);
        make.left.equalTo(19);
        make.right.equalTo(-19);
        make.height.equalTo(0.5);
    }];
    
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [self.bgView addSubview:grayLine];
    [grayLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(15);
        make.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithTitle:@"关闭" font:15*K_SCALE titleColor:@"666666"];
    [leftBtn addTarget:self action:@selector(handClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:leftBtn];
    leftBtn.tag = 1;
    
    [leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(137*K_SCALE);
        make.top.equalTo(grayLine.bottom);
        make.bottom.equalTo(self.bgView.bottom);
//        make.height.equalTo(
    }];
    
    UIButton *rightBtn = [UIButton buttonWithTitle:@"确认" font:15*K_SCALE titleColor:@"09c66a"];
    [rightBtn addTarget:self action:@selector(handClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:rightBtn];
    rightBtn.tag = 2;
    
    [rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.width.equalTo(137*K_SCALE);
        make.top.equalTo(grayLine.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
}

-(void)handClicked:(UIButton *)sender{
    if (sender.tag == 2) {
        //
        if (self.inputTF.text.length ==0) {
            [[MYToast makeText:@"请输入卡密"]show];
            return;
        }
        [[AppRequest sharedInstance]requestActivateCard:[UserTools userID] card:self.inputTF.text Block:^(AppRequestState state, id  _Nonnull result) {
            NSLog(@"激活：：%@",result[@"msg"]);
            if (state == AppRequestState_Success) {
                [[MYToast makeText:@"激活成功"]show];
                [[NSNotificationCenter defaultCenter]postNotificationName:NOT_FRESHMYINFO object:nil];
            }else if (result[@"msg"]){
                [[MYToast makeText:result[@"msg"]]show];
            }else{
               [[MYToast makeText:@"激活失败"]show];
            }
        }];
        
    }
    [self endEditing:YES];
    self.hidden = YES;
}

@end
