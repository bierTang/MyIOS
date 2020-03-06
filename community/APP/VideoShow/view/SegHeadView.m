//
//  SegHeadView.m
//  community
//
//  Created by MAC on 2020/1/5.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "SegHeadView.h"
CGFloat topYidon = 0.0;
UIButton *bt0;
UIButton *bt1;
@implementation SegHeadView

- (instancetype)initWithSegArray:(NSArray *)arr
{
    self = [super init];
    if (self) {
        self.titleArr = arr;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UIScrollView *bgScrol = [[UIScrollView alloc]init];
    [self addSubview:bgScrol];
    [bgScrol makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    bgScrol.showsVerticalScrollIndicator = NO;
    bgScrol.showsHorizontalScrollIndicator = NO;
    
//    bgScrol.backgroundColor = [UIColor cyanColor];
    self.allBtnArr = [NSMutableArray array];
    
    UIButton *lastBtn;
    for (int i = 0; i<self.titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"09c66a"] forState:UIControlStateSelected];
        [bgScrol addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:15*K_SCALE];
        [self.allBtnArr addObject:btn];
        if (i==0) {
            self.saveBtn = btn;
            self.saveBtn.selected = YES;
            self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:20*K_SCALE];
            bt0 = btn;
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(16);
                make.bottom.equalTo(0);
                make.top.equalTo(0);
            }];
            
        }else if(i==self.titleArr.count-1){
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(15);
                make.bottom.equalTo(0);
                make.top.equalTo(0);
                make.right.equalTo(bgScrol.right);
            }];
        }else{
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(15);
                make.bottom.equalTo(0);
                make.top.equalTo(0);
            }];
        }
        lastBtn = btn;
        bt1 = btn;
    }
    
    if (self.allBtnArr.count <= 0) {
        return;
    }
    
    
//    [self.allBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                          withFixedSpacing:10   //item间距
//                               leadSpacing:20   //起始间距
//                               tailSpacing:0]; //结尾间距
//    [self.allBtnArr makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
    
}

-(void)buttonClick:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    self.saveBtn.selected = NO;
    
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:20*K_SCALE];
    
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:15*K_SCALE];
    self.saveBtn = sender;
    if (self.segBlock) {
        self.segBlock(sender.tag);
    }
}

-(void)titleBtnSelected:(NSInteger)index{
    if (index<self.allBtnArr.count) {
        [self buttonClick:self.allBtnArr[index]];
    }
}

-(void)titleBtnSelectedYi:(CGFloat)index{
    

             if (topYidon > index) {
                    
                    bt0.titleLabel.font = [UIFont systemFontOfSize:(20-index*10)*K_SCALE];
                    bt1.titleLabel.font = [UIFont systemFontOfSize:(15+index*10)*K_SCALE];
                   
                }else{
                   
                    bt1.titleLabel.font = [UIFont systemFontOfSize:(15+index*10)*K_SCALE];
                    bt0.titleLabel.font = [UIFont systemFontOfSize:(20-index*10)*K_SCALE];
                }
    topYidon = index;
}
@end
