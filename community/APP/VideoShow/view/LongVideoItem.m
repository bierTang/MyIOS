//
//  LongVideoItem.m
//  community
//
//  Created by MAC on 2020/1/6.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LongVideoItem.h"

@implementation LongVideoItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self makeUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)makeUI{
    self.videoBgImg = [[UIImageView alloc]init];
    self.videoBgImg.image = [UIImage imageNamed:@"longvideoBgImg"];
    [self.contentView addSubview:self.videoBgImg];
    
    [self.videoBgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(104*K_SCALE);
    }];
    
    self.titleLab = [UILabel labelWithTitle:@"说明" font:14 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoBgImg.bottom);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.lessThanOrEqualTo(40*K_SCALE);
    }];
    
    
}

-(void)refreshItem:(PickerModel *)model{

}

@end
