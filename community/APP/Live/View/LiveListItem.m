//
//  LiveListItem.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveListItem.h"

@implementation LiveListItem



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
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImage];
    
    self.bgImage.image = [UIImage imageNamed:@"loadNormal"];
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];    
    self.bgImage.layer.cornerRadius = 8;
    self.bgImage.clipsToBounds = YES;
    
    UIImageView *shaowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadowIcon"]];
    shaowImg.layer.cornerRadius = 8;
    shaowImg.clipsToBounds = YES;
    [self.contentView addSubview:shaowImg];
    [shaowImg makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.right.equalTo(0);
    }];
    
    self.titleLab = [UILabel labelWithTitle:@"乔碧萝" font:17*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(11);
        make.bottom.equalTo(-6);
    }];
    
//    self.onlineNum = [UILabel labelWithTitle:@"999" font:11*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentRight];
//    [self.contentView addSubview:self.onlineNum];
//    [self.onlineNum makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-10);
//        make.bottom.equalTo(-5);
//    }];
//    
//    self.onlineIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"onlineIcon"]];
//    [self.contentView addSubview:self.onlineIcon];
//    [self.onlineIcon makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.onlineNum.left).offset(-5);
//        make.centerY.equalTo(self.onlineNum.centerY);
//    }];
    
}
-(void)refreshItem:(LiveModel *)model{
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
    self.titleLab.text = model.title;
    
    
    
}

@end
