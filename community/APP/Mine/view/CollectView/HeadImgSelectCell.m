//
//  HeadImgSelectCell.m
//  community
//
//  Created by MAC on 2020/1/17.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "HeadImgSelectCell.h"

@implementation HeadImgSelectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self makeUI];
//        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)makeUI{
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    [self.contentView addSubview:self.headImg];
    
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
    }];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"headSelectIcon"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"headSelect_hover"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectBtn];
    
    [self.selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.headImg.bottom).offset(12);
    }];

    
}

-(void)refreshItem:(NSInteger)index andIsSelect:(BOOL)isSelect{
    
    self.headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",index]];
    
    self.selectBtn.selected = isSelect;
    
}

-(void)selectHeadImage:(UIButton *)sender{
    sender.selected = YES;
    
    if (self.headImgSelectBlock) {
        self.headImgSelectBlock(@"");
    }
}


@end
