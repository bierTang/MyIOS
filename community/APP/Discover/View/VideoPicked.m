//
//  VideoPicked.m
//  community
//
//  Created by 蔡文练 on 2019/10/21.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "VideoPicked.h"

@implementation VideoPicked

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(0);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    self.bgImage.backgroundColor = [UIColor blackColor];
//    self.bgImage.image = [UIImage imageNamed:@"cityImage.png"];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"playVideoBtn"] forState:UIControlStateNormal];
    
    [self.playBtn addTarget:self action:@selector(reviewVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.playBtn];
    
    [self.playBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(deleteSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(0);
    }];
    
}

-(void)reviewVideo{
    NSLog(@"预览");
}

-(void)deleteSelect{
    NSLog(@"删除video");
    if (self.delBlock) {
        self.delBlock();
    }
}


@end
