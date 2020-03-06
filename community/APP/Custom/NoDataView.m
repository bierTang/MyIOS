//
//  NoDataView.m
//  community
//
//  Created by 蔡文练 on 2019/11/4.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self initUI:title];
    }
    return self;
}
-(void)initUI:(NSString *)title{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [UILabel labelWithTitle:title font:15 textColor:@"181818" textAlignment:NSTextAlignmentCenter];
    lab.numberOfLines = 0;
    [self addSubview:lab];
    
    [lab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
}
@end
