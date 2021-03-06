//
//  CSCellView.m
//  community
//
//  Created by 蔡文练 on 2019/9/12.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSCellView.h"

@implementation CSCellView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    self.titleLab = [UILabel labelWithTitle:@"" font:12 textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLab];
    
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.subLab = [UILabel labelWithTitle:@"" font:12 textColor:@"999999" textAlignment:NSTextAlignmentRight];
    [self addSubview:self.subLab];
    
    [self.subLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(self.centerY);
    }];
    
    self.arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self addSubview:self.arrowImg];
    
    [self.arrowImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(-16);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
}

-(void)freshTitle:(NSString *)title andSubtitle:(NSString *)subTitle showLine:(BOOL)show{
    self.titleLab.text = title;
    self.subLab.text = subTitle;
    self.arrowImg.hidden = subTitle.length;
    
    self.lineView.hidden = !show;
}

@end
