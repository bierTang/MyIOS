//
//  LiveSegView.m
//  community
//
//  Created by MAC on 2020/2/12.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveSegView.h"

@interface LiveSegView()

@property (nonatomic,strong)UIButton *btn1;
@property (nonatomic,strong)UIButton *btn2;

@end

@implementation LiveSegView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btn1 setTitle:@"推荐" forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.btn1.selected = YES;
    self.btn1.tag = 0;
    [self.btn1 addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *greenView1 = [[UIView alloc]init];
    greenView1.tag = 888;
    greenView1.layer.cornerRadius = 4;
    greenView1.clipsToBounds = YES;
    greenView1.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self addSubview:greenView1];
    
    [self addSubview:self.btn1];
    
    [self.btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(14);
        make.bottom.equalTo(self.bottom);
    }];
    
    [greenView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn1.left);
        make.right.equalTo(self.btn1.right);
        make.bottom.equalTo(self.btn1.bottom).offset(-5);
        make.height.equalTo(8);
    }];
    
    self.self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.self.btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.self.btn2.tag = 1;
    [self.self.btn2 setTitle:@"频道" forState:UIControlStateNormal];
    [self.self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self.btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *greenView2 = [[UIView alloc]init];
    greenView2.tag = 889;
    greenView2.layer.cornerRadius = 4;
    greenView2.clipsToBounds = YES;
    greenView2.hidden = YES;
    greenView2.backgroundColor = [UIColor colorWithHexString:@"09c66a"];
    [self addSubview:greenView2];
    [self addSubview:self.btn2];
    
    [self.btn2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn1.right).offset(15);
        make.bottom.equalTo(self.bottom);
    }];
    [greenView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn2.left);
        make.right.equalTo(self.btn2.right);
        make.bottom.equalTo(self.btn2.bottom).offset(-5);
        make.height.equalTo(8);
    }];
    
    self.saveBtn = self.btn1;
}

-(void)changeSeg:(NSInteger)tag{
    if (tag==0) {
        [self handleClick:self.btn1];
    }else{
        [self handleClick:self.btn2];
    }
}


-(void)handleClick:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    self.saveBtn.selected = NO;
    
    sender.selected = !sender.isSelected;
    
    for (UIView *v in self.subviews) {
        if (v.tag == 888 || v.tag == 889) {
            v.hidden = !v.isHidden;
        }
        
    }
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    self.saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.saveBtn = sender;
    if (self.backBlock) {
        self.backBlock(sender);
    }
    
}
@end
