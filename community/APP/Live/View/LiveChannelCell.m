//
//  LiveChannelCell.m
//  community
//
//  Created by MAC on 2020/2/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveChannelCell.h"

@implementation LiveChannelCell


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
        
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"efefef"].CGColor;
    
    self.bgImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImage];
    
    self.bgImage.image = [UIImage imageNamed:@"headImg_base_1"];
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.equalTo(50*K_SCALE);
        make.width.equalTo(50*K_SCALE);
    }];
    self.bgImage.clipsToBounds = YES;
    self.bgImage.layer.cornerRadius = 25*K_SCALE;
        
    self.titleLab = [UILabel labelWithTitle:@"映客直播" font:15*K_SCALE textColor:@"000000" textAlignment:NSTextAlignmentCenter];
    self.titleLab.font = [UIFont boldSystemFontOfSize:15*K_SCALE];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.bgImage.bottom).offset(10);
    }];
    
    self.onlineIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"liveChannelIcon"]];
    [self.contentView addSubview:self.onlineIcon];
    [self.onlineIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(32*K_SCALE);
        make.top.equalTo(self.titleLab.bottom).offset(10);
    }];
    
    self.onlineNum = [UILabel labelWithTitle:@"999" font:12*K_SCALE textColor:@"09c66a" textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.onlineNum];
    [self.onlineNum makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onlineIcon.right).offset(2);
        make.centerY.equalTo(self.onlineIcon.centerY);
        make.width.equalTo(30*K_SCALE);
    }];
    
}

-(void)refreshItem:(LiveModel *)model{
    
    self.titleLab.text = model.title;
    NSString *imgStr = model.img;
    if (imgStr.length < 6) {
        imgStr = model.xinimg;
    }
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"headImg_base_1"]];
    self.onlineNum.text = model.Number;
    
}
@end
