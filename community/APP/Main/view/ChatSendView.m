//
//  ChatSendView.m
//  community
//
//  Created by 蔡文练 on 2019/10/16.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "ChatSendView.h"

@implementation ChatSendView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{

    self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
    self.addimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addIcon"]];
    [self addSubview:self.addimg];
    [self.addimg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.faceimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"faceIcon"]];
    [self addSubview:self.faceimg];
    [self.faceimg makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addimg.left).offset(-15);
        make.centerY.equalTo(self.centerY);
    }];
    
    
    UIView *forbidView = [[UIView alloc]init];
    forbidView.backgroundColor = [UIColor whiteColor];
    forbidView.layer.cornerRadius=3;
    forbidView.clipsToBounds = YES;
    [self addSubview:forbidView];
    
    [forbidView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.faceimg.left).offset(-24);
        make.height.equalTo(32);
    }];
    
    self.forbidenlab = [UILabel labelWithTitle:@"禁言中" font:14 textColor:@"161616" textAlignment:NSTextAlignmentCenter];
    [forbidView addSubview:self.forbidenlab];
    [self.forbidenlab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
    
    
    
}


@end
