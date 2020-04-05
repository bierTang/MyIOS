//
//  CSSameCityItem.m
//  community
//
//  Created by 蔡文练 on 2019/9/6.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSSameCityItem.h"

@implementation CSSameCityItem

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
    
//    self.layer.cornerRadius = 5;
//    self.layer.shadowOffset = CGSizeMake(2, 2);
//    self.layer.shadowColor = [UIColor colorWithHexString:@"b8b8b8"].CGColor;
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOpacity = 1;
    
    
//    self.backgroundColor = RGBColor(random()%255, random()%255, random()%244);
    CGFloat kk = K_SCALE;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    
    self.headImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cityImage"]];
    [self addSubview:self.headImg];
    
    [self.headImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(11*kk);
        make.centerY.equalTo(self.centerY);
        make.height.width.equalTo(30*kk);
    }];
    
    
    self.provinceLab = [UILabel labelWithTitle:@"北京同城" font:14*kk textColor:@"181818" textAlignment:NSTextAlignmentCenter];
    self.provinceLab.font = [UIFont boldSystemFontOfSize:14*kk];
    [self addSubview:self.provinceLab];
    
    [self.provinceLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.right).offset(4*kk);
        make.top.equalTo(self.headImg).offset(-1*kk);
    }];
    
    self.postNum_Lab = [UILabel labelWithTitle:@"帖数：12345" font:11*kk textColor:@"6e6e6e" textAlignment:NSTextAlignmentRight];
    [self addSubview:self.postNum_Lab];
    
    [self.postNum_Lab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.provinceLab);
        make.bottom.equalTo(self.headImg.bottom).offset(1);
    }];
    
    
    
}

-(void)refreshItem:(CityListModel *)model{
    self.postNum_Lab.text = [NSString stringWithFormat:@"帖数：%@",model.post_num];//@"帖数：22345";
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[CSCaches shareInstance].webUrl,model.path]] placeholderImage:[UIImage imageNamed:@"head_moren"]];
    
    self.provinceLab.text = model.name;//@"北京同城";
    
}



@end
